"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.evaluateSandboxCard = evaluateSandboxCard;
exports.createPaymentIntentRecord = createPaymentIntentRecord;
exports.confirmPaymentRecord = confirmPaymentRecord;
const admin = __importStar(require("firebase-admin"));
const functions = __importStar(require("firebase-functions/v1"));
const db = admin.firestore();
/** Stripe-style sandbox test cards for portfolio demos. */
const SANDBOX_CARDS = {
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
function normalizeCardNumber(cardNumber) {
    return cardNumber.replace(/\D/g, "");
}
function detectCardBrand(cardNumber) {
    if (cardNumber.startsWith("4"))
        return "visa";
    if (cardNumber.startsWith("5"))
        return "mastercard";
    if (cardNumber.startsWith("3"))
        return "amex";
    return "sandbox";
}
function evaluateSandboxCard(cardNumber) {
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
async function createPaymentIntentRecord(params) {
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
async function confirmPaymentRecord(params) {
    const paymentRef = db.collection("payments").doc(params.paymentId);
    const paymentSnap = await paymentRef.get();
    if (!paymentSnap.exists) {
        throw new functions.https.HttpsError("not-found", "Payment not found.");
    }
    const payment = paymentSnap.data();
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
//# sourceMappingURL=sandbox_payment.js.map