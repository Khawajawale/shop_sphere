"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.secureCallable = secureCallable;
const errors_1 = require("./errors");
const callable_types_1 = require("./callable_types");
const rate_limiter_1 = require("./rate_limiter");
/**
 * Wraps v1 callable functions with auth, rate limiting, and safe error handling.
 */
function secureCallable(tier, options, handler) {
    return async (data, context) => {
        const request = (0, callable_types_1.toCallableRequest)(data, context);
        try {
            await (0, rate_limiter_1.enforceRateLimit)(request, tier);
            const uid = options.requireAuth === false
                ? request.auth?.uid ?? ""
                : (0, errors_1.requireAuth)(request);
            return await handler(request, uid);
        }
        catch (error) {
            (0, errors_1.handleCallableError)(error, handler.name || "callable");
        }
    };
}
//# sourceMappingURL=callable_wrapper.js.map