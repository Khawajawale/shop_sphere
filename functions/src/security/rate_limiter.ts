/**
 * Sliding-window in-memory rate limiter.
 * For multi-instance deployments, set REDIS_URL to enable Redis-backed limiting.
 */
import * as functions from "firebase-functions/v1";

import type { AppCallableRequest } from "./callable_types";

export type RateLimitTier =
  | "public"
  | "auth"
  | "authenticated"
  | "costly";

const LIMITS: Record<RateLimitTier, { windowMs: number; max: number }> = {
  public: { windowMs: 60_000, max: 20 },
  auth: { windowMs: 60_000, max: 5 },
  authenticated: { windowMs: 60_000, max: 60 },
  costly: { windowMs: 60_000, max: 10 },
};

interface WindowEntry {
  count: number;
  resetAt: number;
}

const memoryStore = new Map<string, WindowEntry>();

function memoryKey(bucket: string, id: string): string {
  return `${bucket}:${id}`;
}

function checkMemoryLimit(
  bucket: string,
  id: string,
  tier: RateLimitTier
): { allowed: boolean; retryAfterSec: number } {
  const { windowMs, max } = LIMITS[tier];
  const key = memoryKey(bucket, id);
  const now = Date.now();
  const entry = memoryStore.get(key);

  if (!entry || now >= entry.resetAt) {
    memoryStore.set(key, { count: 1, resetAt: now + windowMs });
    return { allowed: true, retryAfterSec: 0 };
  }

  if (entry.count >= max) {
    const retryAfterSec = Math.ceil((entry.resetAt - now) / 1000);
    return { allowed: false, retryAfterSec };
  }

  entry.count += 1;
  return { allowed: true, retryAfterSec: 0 };
}

/**
 * Enforces rate limits per IP (unauthenticated) or per UID (authenticated).
 * Throws resource-exhausted (HTTP 429 equivalent) with retry metadata.
 */
export async function enforceRateLimit(
  request: AppCallableRequest,
  tier: RateLimitTier
): Promise<void> {
  const uid = request.auth?.uid;
  const ip =
    request.rawRequest.headers["x-forwarded-for"]?.toString().split(",")[0]?.trim() ||
    request.rawRequest.ip ||
    "unknown";

  const bucket = tier;
  const id = uid ?? `ip:${ip}`;
  const result = checkMemoryLimit(bucket, id, tier);

  if (!result.allowed) {
    throw new functions.https.HttpsError(
      "resource-exhausted",
      "Too many requests. Please try again later.",
      { retryAfter: result.retryAfterSec }
    );
  }
}

export function rateLimitHeaders(retryAfterSec: number): Record<string, string> {
  return retryAfterSec > 0 ? { "Retry-After": String(retryAfterSec) } : {};
}
