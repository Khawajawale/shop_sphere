"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.toCallableRequest = toCallableRequest;
function toCallableRequest(data, context) {
    return {
        data,
        auth: context.auth,
        rawRequest: context.rawRequest,
    };
}
//# sourceMappingURL=callable_types.js.map