import * as admin from "firebase-admin";
import * as functions from "firebase-functions/v1";

import { apiHealth } from "./http/security_headers";
import {
  confirmPaymentRecord,
  createPaymentIntentRecord,
} from "./payments/sandbox_payment";
import { productSeedData, toFirestoreProduct } from "./seed/product_seed_data";
import { secureCallable } from "./security/callable_wrapper";
import {
  confirmSandboxPaymentSchema,
  createPaymentIntentSchema,
  parseInput,
  setUserRoleSchema,
  updateOrderStatusSchema,
  upsertProductSchema,
} from "./security/validation";

admin.initializeApp();

const db = admin.firestore();

export { apiHealth };

type UserRole = "customer" | "staff" | "manager" | "admin";

const roleLevel: Record<UserRole, number> = {
  customer: 0,
  staff: 1,
  manager: 2,
  admin: 3,
};

async function getCallerRole(uid: string): Promise<UserRole> {
  const doc = await db.collection("users").doc(uid).get();
  return (doc.data()?.role as UserRole) ?? "customer";
}

function hasAtLeast(role: UserRole, required: UserRole): boolean {
  return roleLevel[role] >= roleLevel[required];
}

export const setUserRole = functions.https.onCall(
  secureCallable("authenticated", { requireAuth: true }, async (request, uid) => {
    const callerRole = await getCallerRole(uid);
    if (!hasAtLeast(callerRole, "admin")) {
      throw new functions.https.HttpsError("permission-denied", "Admin only.");
    }

    const { userId, role } = parseInput(setUserRoleSchema, request.data);
    await db.collection("users").doc(userId).set({ role }, { merge: true });
    return { success: true };
  })
);

export const upsertProduct = functions.https.onCall(
  secureCallable("authenticated", { requireAuth: true }, async (request, uid) => {
    const callerRole = await getCallerRole(uid);
    if (!hasAtLeast(callerRole, "manager")) {
      throw new functions.https.HttpsError("permission-denied", "Manager required.");
    }

    const { productId, data } = parseInput(upsertProductSchema, request.data);
    await db.collection("products").doc(productId).set(data, { merge: true });
    return { success: true, productId };
  })
);

export const updateOrderStatus = functions.https.onCall(
  secureCallable("authenticated", { requireAuth: true }, async (request, uid) => {
    const callerRole = await getCallerRole(uid);
    if (!hasAtLeast(callerRole, "staff")) {
      throw new functions.https.HttpsError("permission-denied", "Staff required.");
    }

    const { orderId, status } = parseInput(updateOrderStatusSchema, request.data);

    const orderRef = db.collection("orders").doc(orderId);
    const orderSnap = await orderRef.get();
    if (!orderSnap.exists) {
      throw new functions.https.HttpsError("not-found", "Order not found.");
    }

    await orderRef.update({ status });

    const order = orderSnap.data()!;
    const userId = order.userId as string;
    const userSnap = await db.collection("users").doc(userId).get();
    const fcmToken = userSnap.data()?.fcmToken as string | undefined;

    if (fcmToken) {
      await admin.messaging().send({
        token: fcmToken,
        notification: {
          title: "Order Update",
          body: `Your order status has been updated.`,
        },
        data: { type: "order", orderId },
      });
    }

    return { success: true };
  })
);

export const onOrderCreated = functions.firestore
  .document("orders/{orderId}")
  .onCreate(async (snap, context) => {
    const order = snap.data();
    const userId = order.userId as string;
    const userSnap = await db.collection("users").doc(userId).get();
    const fcmToken = userSnap.data()?.fcmToken as string | undefined;

    if (!fcmToken) return;

    await admin.messaging().send({
      token: fcmToken,
      notification: {
        title: "Order Confirmed",
        body: "Your order has been placed successfully.",
      },
      data: { type: "order", orderId: context.params.orderId },
    });
  });

export const seedProducts = functions.https.onCall(
  secureCallable("costly", { requireAuth: true }, async (_request, uid) => {
    const callerRole = await getCallerRole(uid);
    if (!hasAtLeast(callerRole, "admin")) {
      throw new functions.https.HttpsError("permission-denied", "Admin only.");
    }

    const batch = db.batch();
    for (const product of productSeedData) {
      const ref = db.collection("products").doc(product.id);
      batch.set(ref, toFirestoreProduct(product), { merge: true });
    }
    await batch.commit();

    return { success: true, seededCount: productSeedData.length };
  })
);

export const createPaymentIntent = functions.https.onCall(
  secureCallable("costly", { requireAuth: true }, async (request, uid) => {
    const { amount, currency, orderId } = parseInput(
      createPaymentIntentSchema,
      request.data
    );

    return createPaymentIntentRecord({
      userId: uid,
      amount,
      currency: currency ?? "usd",
      orderId,
    });
  })
);

export const confirmSandboxPayment = functions.https.onCall(
  secureCallable("costly", { requireAuth: true }, async (request, uid) => {
    const { paymentId, cardNumber, expMonth, expYear, cvc } = parseInput(
      confirmSandboxPaymentSchema,
      request.data
    );

    return confirmPaymentRecord({
      paymentId,
      userId: uid,
      cardNumber,
      expMonth,
      expYear,
      cvc,
    });
  })
);
