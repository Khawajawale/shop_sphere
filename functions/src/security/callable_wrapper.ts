import type { CallableContext } from "firebase-functions/v1/https";

import { handleCallableError, requireAuth } from "./errors";
import { AppCallableRequest, toCallableRequest } from "./callable_types";
import { enforceRateLimit, RateLimitTier } from "./rate_limiter";

type CallableHandler<T> = (
  request: AppCallableRequest,
  uid: string
) => Promise<T>;

/**
 * Wraps v1 callable functions with auth, rate limiting, and safe error handling.
 */
export function secureCallable<T>(
  tier: RateLimitTier,
  options: { requireAuth?: boolean },
  handler: CallableHandler<T>
) {
  return async (data: unknown, context: CallableContext): Promise<T> => {
    const request = toCallableRequest(data, context);

    try {
      await enforceRateLimit(request, tier);

      const uid = options.requireAuth === false
        ? request.auth?.uid ?? ""
        : requireAuth(request);

      return await handler(request, uid);
    } catch (error) {
      handleCallableError(error, handler.name || "callable");
    }
  };
}
