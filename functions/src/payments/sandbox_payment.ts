import * as admin from "firebase-admin";
import * as functions from "firebase-functions/v1";

const db = admin.firestore();

export type PaymentStatus =
  | "requires_payment_method"
  | "processing"
  | "succeeded"
  | "failed";

interface SandboxCardResult {
  status: PaymentStatus;
  failureReason?: string;
  cardBrand: string;
  last4: string;
}

/** Stripe-style sandbox test cards for portfolio demos. */
const SANDBOX_CARDS: Record<string, Omit<SandboxCardResult, "cardBrand" | "last4">> = {
  "4242424242424242": { status: "succeeded" },
  "4000000000000002": {
    status: "failed",
    failureReason: "Your card was declined.",
  },
  "4000000000009995": {
    status: "failed",
    failureReason: "Insufficient funds.",
  },
};

function normalizeCardNumber(cardNumber: string): string {
  return cardNumber.replace(/\D/g, "");
}

function detectCardBrand(cardNumber: string): string {
  if (cardNumber.startsWith("4")) return "visa";
  if (cardNumber.startsWith("5")) return "mastercard";
  if (cardNumber.startsWith("3")) return "amex";
  return "sandbox";
}

export function evaluateSandboxCard(cardNumber: string): SandboxCardResult {
  const normalized = normalizeCardNumber(cardNumber);

  if (normalized.length < 13 || normalized.length > 19) {
    return {
      status: "failed",
      failureReason: "Invalid card number.",
      cardBrand: "unknown",
      last4: normalized.slice(-4).padStart(4, "0"),
    };
  }

  const preset = SANDBOX_CARDS[normalized];
  const last4 = normalized.slice(-4);
  const cardBrand = detectCardBrand(normalized);

  if (preset) {
    return { ...preset, cardBrand, last4 };
  }

  // Default: succeed for any other valid-length test card
  return { status: "succeeded", cardBrand, last4 };
}

export async function createPaymentIntentRecord(params: {
  userId: string;
  amount: number;
  currency: string;
  orderId?: string;
}): Promise<{ paymentId: string; clientSecret: string }> {
  const paymentRef = db.collection("payments").doc();
  const clientSecret = `sandbox_${paymentRef.id}_${Date.now()}`;

  await paymentRef.set({
    userId: params.userId,
    amount: params.amount,
    currency: params.currency,
    status: "requires_payment_method",
    orderId: params.orderId ?? null,
    clientSecret,
    provider: "sandbox",
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  return { paymentId: paymentRef.id, clientSecret };
}

export async function confirmPaymentRecord(params: {
  paymentId: string;
  userId: string;
  cardNumber: string;
  expMonth: string;
  expYear: string;
  cvc: string;
}): Promise<{
  status: PaymentStatus;
  failureReason?: string;
  last4?: string;
  cardBrand?: string;
}> {
  const paymentRef = db.collection("payments").doc(params.paymentId);
  const paymentSnap = await paymentRef.get();

  if (!paymentSnap.exists) {
    throw new functions.https.HttpsError("not-found", "Payment not found.");
  }

  const payment = paymentSnap.data()!;
  if (payment.userId !== params.userId) {
    throw new functions.https.HttpsError("permission-denied", "Not your payment.");
  }

  if (payment.status === "succeeded") {
    return {
      status: "succeeded",
      last4: payment.last4,
      cardBrand: payment.cardBrand,
    };
  }

  const expMonth = parseInt(params.expMonth, 10);
  const expYear = parseInt(params.expYear.length === 2 ? `20${params.expYear}` : params.expYear, 10);
  const now = new Date();

  if (Number.isNaN(expMonth) || Number.isNaN(expYear)) {
    throw new functions.https.HttpsError("invalid-argument", "Invalid expiry date.");
  }

  if (params.cvc.length < 3 || params.cvc.length > 4) {
    throw new functions.https.HttpsError("invalid-argument", "Invalid CVC.");
  }

  const expiry = new Date(expYear, expMonth, 0);
  if (expiry < now) {
    await paymentRef.update({
      status: "failed",
      failureReason: "Card has expired.",
      confirmedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    return { status: "failed", failureReason: "Card has expired." };
  }

  await paymentRef.update({ status: "processing" });

  // Simulate network latency for realistic UX
  await new Promise((resolve) => setTimeout(resolve, 800));

  const result = evaluateSandboxCard(params.cardNumber);

  await paymentRef.update({
    status: result.status,
    failureReason: result.failureReason ?? null,
    last4: result.last4,
    cardBrand: result.cardBrand,
    confirmedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  return {
    status: result.status,
    failureReason: result.failureReason,
    last4: result.last4,
    cardBrand: result.cardBrand,
  };
}
