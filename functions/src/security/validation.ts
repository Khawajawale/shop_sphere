import { z } from "zod";
import * as functions from "firebase-functions/v1";

const userRoleSchema = z.enum(["customer", "staff", "manager", "admin"]);

const uidSchema = z.string().min(1).max(128).regex(/^[a-zA-Z0-9_-]+$/);

export const setUserRoleSchema = z
  .object({
    userId: uidSchema,
    role: userRoleSchema,
  })
  .strict();

export const upsertProductSchema = z
  .object({
    productId: z.string().min(1).max(64).regex(/^[a-zA-Z0-9_-]+$/),
    data: z
      .object({
        name: z.string().min(1).max(200),
        description: z.string().min(1).max(2000),
        price: z.number().min(0).max(100_000),
        salePrice: z.number().min(0).max(100_000).optional(),
        images: z.array(z.string().url().max(500)).max(10),
        categoryId: z.string().min(1).max(40),
        inStock: z.boolean(),
        stockQuantity: z.number().int().min(0).max(1_000_000),
        rating: z.number().min(0).max(5),
        reviewCount: z.number().int().min(0).max(10_000_000),
        featured: z.boolean(),
        createdAt: z.string().max(40),
      })
      .strict(),
  })
  .strict();

export const orderStatusSchema = z.enum([
  "Pending",
  "Processing",
  "Confirmed",
  "Shipped",
  "Delivered",
  "Cancelled",
]);

export const updateOrderStatusSchema = z
  .object({
    orderId: z.string().min(1).max(64),
    status: orderStatusSchema,
  })
  .strict();

export const createPaymentIntentSchema = z
  .object({
    amount: z.number().positive().max(100_000),
    currency: z.enum(["usd"]).default("usd"),
    orderId: z.string().min(1).max(64).optional(),
  })
  .strict();

export const confirmSandboxPaymentSchema = z
  .object({
    paymentId: z.string().min(1).max(128),
    cardNumber: z.string().min(13).max(19),
    expMonth: z.string().min(1).max(2),
    expYear: z.string().min(2).max(4),
    cvc: z.string().min(3).max(4),
  })
  .strict();

export function parseInput<T>(
  schema: z.ZodType<T>,
  data: unknown
): T {
  const result = schema.safeParse(data);
  if (!result.success) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Invalid request data."
    );
  }
  return result.data;
}
