import * as functions from "firebase-functions/v1";
import type { Response } from "express";

const SECURITY_HEADERS: Record<string, string> = {
  "Content-Security-Policy": "default-src 'self'",
  "X-Frame-Options": "DENY",
  "X-Content-Type-Options": "nosniff",
  "Referrer-Policy": "strict-origin-when-cross-origin",
  "Permissions-Policy": "camera=(), microphone=(), geolocation=()",
  "Strict-Transport-Security": "max-age=31536000; includeSubDomains",
};

function getAllowedOrigins(): string[] {
  const raw = process.env.ALLOWED_CORS_ORIGINS ?? "";
  return raw
    .split(",")
    .map((o) => o.trim())
    .filter(Boolean);
}

export function applySecurityHeaders(
  res: Response,
  origin?: string
): void {
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
export const apiHealth = functions.https.onRequest((req, res) => {
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
