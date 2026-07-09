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
exports.confirmSandboxPaymentSchema = exports.createPaymentIntentSchema = exports.updateOrderStatusSchema = exports.orderStatusSchema = exports.upsertProductSchema = exports.setUserRoleSchema = void 0;
exports.parseInput = parseInput;
const zod_1 = require("zod");
const functions = __importStar(require("firebase-functions/v1"));
const userRoleSchema = zod_1.z.enum(["customer", "staff", "manager", "admin"]);
const uidSchema = zod_1.z.string().min(1).max(128).regex(/^[a-zA-Z0-9_-]+$/);
exports.setUserRoleSchema = zod_1.z
    .object({
    userId: uidSchema,
    role: userRoleSchema,
})
    .strict();
exports.upsertProductSchema = zod_1.z
    .object({
    productId: zod_1.z.string().min(1).max(64).regex(/^[a-zA-Z0-9_-]+$/),
    data: zod_1.z
        .object({
        name: zod_1.z.string().min(1).max(200),
        description: zod_1.z.string().min(1).max(2000),
        price: zod_1.z.number().min(0).max(100000),
        salePrice: zod_1.z.number().min(0).max(100000).optional(),
        images: zod_1.z.array(zod_1.z.string().url().max(500)).max(10),
        categoryId: zod_1.z.string().min(1).max(40),
        inStock: zod_1.z.boolean(),
        stockQuantity: zod_1.z.number().int().min(0).max(1000000),
        rating: zod_1.z.number().min(0).max(5),
        reviewCount: zod_1.z.number().int().min(0).max(10000000),
        featured: zod_1.z.boolean(),
        createdAt: zod_1.z.string().max(40),
    })
        .strict(),
})
    .strict();
exports.orderStatusSchema = zod_1.z.enum([
    "Pending",
    "Processing",
    "Confirmed",
    "Shipped",
    "Delivered",
    "Cancelled",
]);
exports.updateOrderStatusSchema = zod_1.z
    .object({
    orderId: zod_1.z.string().min(1).max(64),
    status: exports.orderStatusSchema,
})
    .strict();
exports.createPaymentIntentSchema = zod_1.z
    .object({
    amount: zod_1.z.number().positive().max(100000),
    currency: zod_1.z.enum(["usd"]).default("usd"),
    orderId: zod_1.z.string().min(1).max(64).optional(),
})
    .strict();
exports.confirmSandboxPaymentSchema = zod_1.z
    .object({
    paymentId: zod_1.z.string().min(1).max(128),
    cardNumber: zod_1.z.string().min(13).max(19),
    expMonth: zod_1.z.string().min(1).max(2),
    expYear: zod_1.z.string().min(2).max(4),
    cvc: zod_1.z.string().min(3).max(4),
})
    .strict();
function parseInput(schema, data) {
    const result = schema.safeParse(data);
    if (!result.success) {
        throw new functions.https.HttpsError("invalid-argument", "Invalid request data.");
    }
    return result.data;
}
//# sourceMappingURL=validation.js.map