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
exports.apiHealth = void 0;
exports.applySecurityHeaders = applySecurityHeaders;
const functions = __importStar(require("firebase-functions/v1"));
const SECURITY_HEADERS = {
    "Content-Security-Policy": "default-src 'self'",
    "X-Frame-Options": "DENY",
    "X-Content-Type-Options": "nosniff",
    "Referrer-Policy": "strict-origin-when-cross-origin",
    "Permissions-Policy": "camera=(), microphone=(), geolocation=()",
    "Strict-Transport-Security": "max-age=31536000; includeSubDomains",
};
function getAllowedOrigins() {
    const raw = process.env.ALLOWED_CORS_ORIGINS ?? "";
    return raw
        .split(",")
        .map((o) => o.trim())
        .filter(Boolean);
}
function applySecurityHeaders(res, origin) {
    for (const [key, value] of Object.entries(SECURITY_HEADERS)) {
        res.setHeader(key, value);
    }
    const allowed = getAllowedOrigins();
    if (origin && allowed.includes(origin)) {
        res.setHeader("Access-Control-Allow-Origin", origin);
        res.setHeader("Vary", "Origin");
    }
}
/**
 * Health endpoint with security headers and explicit CORS allowlist (no wildcard).
 */
exports.apiHealth = functions.https.onRequest((req, res) => {
    if (req.method === "OPTIONS") {
        applySecurityHeaders(res, req.get("origin"));
        res.setHeader("Access-Control-Allow-Methods", "GET, OPTIONS");
        res.setHeader("Access-Control-Allow-Headers", "Content-Type");
        res.status(204).send("");
        return;
    }
    if (req.secure === false && process.env.NODE_ENV === "production") {
        res.redirect(301, `https://${req.hostname}${req.url}`);
        return;
    }
    applySecurityHeaders(res, req.get("origin"));
    res.status(200).json({ status: "ok" });
});
//# sourceMappingURL=security_headers.js.map