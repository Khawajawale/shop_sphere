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
exports.confirmSandboxPayment = exports.createPaymentIntent = exports.seedProducts = exports.onOrderCreated = exports.updateOrderStatus = exports.upsertProduct = exports.setUserRole = exports.apiHealth = void 0;
const admin = __importStar(require("firebase-admin"));
const functions = __importStar(require("firebase-functions/v1"));
const security_headers_1 = require("./http/security_headers");
Object.defineProperty(exports, "apiHealth", { enumerable: true, get: function () { return security_headers_1.apiHealth; } });
const sandbox_payment_1 = require("./payments/sandbox_payment");
const product_seed_data_1 = require("./seed/product_seed_data");
const callable_wrapper_1 = require("./security/callable_wrapper");
const validation_1 = require("./security/validation");
admin.initializeApp();
const db = admin.firestore();
const roleLevel = {
    customer: 0,
    staff: 1,
    manager: 2,
    admin: 3,
};
async function getCallerRole(uid) {
    const doc = await db.collection("users").doc(uid).get();
    return doc.data()?.role ?? "customer";
}
function hasAtLeast(role, required) {
    return roleLevel[role] >= roleLevel[required];
}
exports.setUserRole = functions.https.onCall((0, callable_wrapper_1.secureCallable)("authenticated", { requireAuth: true }, async (request, uid) => {
    const callerRole = await getCallerRole(uid);
    if (!hasAtLeast(callerRole, "admin")) {
        throw new functions.https.HttpsError("permission-denied", "Admin only.");
    }
    const { userId, role } = (0, validation_1.parseInput)(validation_1.setUserRoleSchema, request.data);
    await db.collection("users").doc(userId).set({ role }, { merge: true });
    return { success: true };
}));
exports.upsertProduct = functions.https.onCall((0, callable_wrapper_1.secureCallable)("authenticated", { requireAuth: true }, async (request, uid) => {
    const callerRole = await getCallerRole(uid);
    if (!hasAtLeast(callerRole, "manager")) {
        throw new functions.https.HttpsError("permission-denied", "Manager required.");
    }
    const { productId, data } = (0, validation_1.parseInput)(validation_1.upsertProductSchema, request.data);
    await db.collection("products").doc(productId).set(data, { merge: true });
    return { success: true, productId };
}));
exports.updateOrderStatus = functions.https.onCall((0, callable_wrapper_1.secureCallable)("authenticated", { requireAuth: true }, async (request, uid) => {
    const callerRole = await getCallerRole(uid);
    if (!hasAtLeast(callerRole, "staff")) {
        throw new functions.https.HttpsError("permission-denied", "Staff required.");
    }
    const { orderId, status } = (0, validation_1.parseInput)(validation_1.updateOrderStatusSchema, request.data);
    const orderRef = db.collection("orders").doc(orderId);
    const orderSnap = await orderRef.get();
    if (!orderSnap.exists) {
        throw new functions.https.HttpsError("not-found", "Order not found.");
    }
    await orderRef.update({ status });
    const order = orderSnap.data();
    const userId = order.userId;
    const userSnap = await db.collection("users").doc(userId).get();
    const fcmToken = userSnap.data()?.fcmToken;
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
}));
exports.onOrderCreated = functions.firestore
    .document("orders/{orderId}")
    .onCreate(async (snap, context) => {
    const order = snap.data();
    const userId = order.userId;
    const userSnap = await db.collection("users").doc(userId).get();
    const fcmToken = userSnap.data()?.fcmToken;
    if (!fcmToken)
        return;
    await admin.messaging().send({
        token: fcmToken,
        notification: {
            title: "Order Confirmed",
            body: "Your order has been placed successfully.",
        },
        data: { type: "order", orderId: context.params.orderId },
    });
});
exports.seedProducts = functions.https.onCall((0, callable_wrapper_1.secureCallable)("costly", { requireAuth: true }, async (_request, uid) => {
    const callerRole = await getCallerRole(uid);
    if (!hasAtLeast(callerRole, "admin")) {
        throw new functions.https.HttpsError("permission-denied", "Admin only.");
    }
    const batch = db.batch();
    for (const product of product_seed_data_1.productSeedData) {
        const ref = db.collection("products").doc(product.id);
        batch.set(ref, (0, product_seed_data_1.toFirestoreProduct)(product), { merge: true });
    }
    await batch.commit();
    return { success: true, seededCount: product_seed_data_1.productSeedData.length };
}));
exports.createPaymentIntent = functions.https.onCall((0, callable_wrapper_1.secureCallable)("costly", { requireAuth: true }, async (request, uid) => {
    const { amount, currency, orderId } = (0, validation_1.parseInput)(validation_1.createPaymentIntentSchema, request.data);
    return (0, sandbox_payment_1.createPaymentIntentRecord)({
        userId: uid,
        amount,
        currency: currency ?? "usd",
        orderId,
    });
}));
exports.confirmSandboxPayment = functions.https.onCall((0, callable_wrapper_1.secureCallable)("costly", { requireAuth: true }, async (request, uid) => {
    const { paymentId, cardNumber, expMonth, expYear, cvc } = (0, validation_1.parseInput)(validation_1.confirmSandboxPaymentSchema, request.data);
    return (0, sandbox_payment_1.confirmPaymentRecord)({
        paymentId,
        userId: uid,
        cardNumber,
        expMonth,
        expYear,
        cvc,
    });
}));
//# sourceMappingURL=index.js.map