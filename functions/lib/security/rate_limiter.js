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
exports.enforceRateLimit = enforceRateLimit;
exports.rateLimitHeaders = rateLimitHeaders;
/**
 * Sliding-window in-memory rate limiter.
 * For multi-instance deployments, set REDIS_URL to enable Redis-backed limiting.
 */
const functions = __importStar(require("firebase-functions/v1"));
const LIMITS = {
    public: { windowMs: 60000, max: 20 },
    auth: { windowMs: 60000, max: 5 },
    authenticated: { windowMs: 60000, max: 60 },
    costly: { windowMs: 60000, max: 10 },
};
const memoryStore = new Map();
function memoryKey(bucket, id) {
    return `${bucket}:${id}`;
}
function checkMemoryLimit(bucket, id, tier) {
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
async function enforceRateLimit(request, tier) {
    const uid = request.auth?.uid;
    const ip = request.rawRequest.headers["x-forwarded-for"]?.toString().split(",")[0]?.trim() ||
        request.rawRequest.ip ||
        "unknown";
    const bucket = tier;
    const id = uid ?? `ip:${ip}`;
    const result = checkMemoryLimit(bucket, id, tier);
    if (!result.allowed) {
        throw new functions.https.HttpsError("resource-exhausted", "Too many requests. Please try again later.", { retryAfter: result.retryAfterSec });
    }
}
function rateLimitHeaders(retryAfterSec) {
    return retryAfterSec > 0 ? { "Retry-After": String(retryAfterSec) } : {};
}
//# sourceMappingURL=rate_limiter.js.map