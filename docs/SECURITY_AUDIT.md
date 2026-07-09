# ShopSphere Security Audit Report

**Date:** 2026-07-08  
**Scope:** Full codebase (Flutter client, Firestore/Storage rules, Cloud Functions, scripts, CI)

---

## PHASE 1 — DISCOVERY

### [A] Secrets & credentials in source control

| # | Issue | Location |
|---|-------|----------|
| A1 | Firebase API keys hardcoded in `firebase_options.dart` | `lib/firebase_options.dart` |
| A2 | Firebase Android config committed with API key | `android/app/google-services.json` |
| A3 | `.env` not gitignored; no `.env.example` | `.gitignore` |
| A4 | Keystore paths/passwords not excluded from VCS | `.gitignore` |
| A5 | Service account JSON pattern not excluded | `.gitignore` |

### [B] Rate limiting

| # | Issue | Location |
|---|-------|----------|
| B1 | `setUserRole` — no rate limit | `functions/src/index.ts` |
| B2 | `upsertProduct` — no rate limit | `functions/src/index.ts` |
| B3 | `updateOrderStatus` — no rate limit | `functions/src/index.ts` |
| B4 | `seedProducts` — no rate limit | `functions/src/index.ts` |
| B5 | `createPaymentIntent` — no rate limit | `functions/src/index.ts` |
| B6 | `confirmSandboxPayment` — no rate limit | `functions/src/index.ts` |

> Firebase Auth (login/register/reset) has platform-level throttling via `too-many-requests`.

### [C] Input validation

| # | Issue | Location |
|---|-------|----------|
| C1 | **CRITICAL:** Users could self-assign `role: admin` on create/update | `firestore.rules` |
| C2 | Orders accepted arbitrary `totalAmount` / fake `paymentStatus` | `firestore.rules` |
| C3 | Product writes accepted arbitrary fields | `firestore.rules` |
| C4 | Any signed-in user could write to `products/` storage | `storage.rules` |
| C5 | `upsertProduct` accepted unvalidated `data` blob | `functions/src/index.ts` |
| C6 | `updateOrderStatus` accepted arbitrary status strings | `functions/src/index.ts` |
| C7 | `setUserRole` weak field validation | `functions/src/index.ts` |
| C8 | Payment intents lacked max amount / currency whitelist | `functions/src/index.ts` |
| C9 | Checkout address fields — no max length | `checkout_page.dart` |
| C10 | Search query — no length cap | `search_page.dart` |
| C11 | Profile name/phone — no server-side length checks | `auth_repository_impl.dart` |
| C12 | Product route param — no format validation | `app_router.dart` |

### [D] Auth & sessions

| # | Issue | Location |
|---|-------|----------|
| D1 | No route guards on checkout, admin, profile, cart, orders | `app_router.dart` |
| D2 | Admin panel relied only on client-side `PermissionChecker` | `admin_dashboard_page.dart` |
| D3 | Catalog seed available to managers via client batch write | `admin_dashboard_page.dart` |
| D4 | Release builds could bypass payment Cloud Functions via local fallback | `payment_remote_datasource.dart` |

> Custom JWT 15 min / refresh 7 days, CSRF tokens, and HttpOnly cookies do not apply to this **mobile + Firebase SDK** architecture. See [STILL AT RISK](#still-at-risk).

### [E] Prompt injection (LLM)

| # | Issue | Location |
|---|-------|----------|
| E1 | N/A — no LLM integration in codebase | — |

### [F] CORS & security headers

| # | Issue | Location |
|---|-------|----------|
| F1 | No HTTP endpoints with security headers | `functions/` |
| F2 | No explicit CORS allowlist | `functions/` |
| F3 | No HSTS / HTTPS redirect | `functions/` |

### [G] Error handling & information disclosure

| # | Issue | Location |
|---|-------|----------|
| G1 | `auth_controller` exposed `e.toString()` to UI | `auth_controller.dart` |
| G2 | `exception_mapper` default leaked Firebase `e.message` | `exception_mapper.dart` |
| G3 | `auth_remote_datasource` default leaked `e.message` | `auth_remote_datasource.dart` |
| G4 | `catalog_seed_provider` exposed `e.toString()` | `catalog_seed_provider.dart` |
| G5 | `payment_provider` exposed `e.toString()` | `payment_provider.dart` |
| G6 | `product_controller` exposed `e.toString()` | `product_controller.dart` |
| G7 | FCM debug log could include exception details | `messaging_service.dart` |
| G8 | Seed script logged full error object | `scripts/seed_firestore.js` |

---

## PHASE 2 — FIXES APPLIED

See [FIXED](#fixed) section in README security summary below.

---

## PHASE 3 — POST-AUDIT STATUS

### FIXED

| ID | File(s) | Fix |
|----|---------|-----|
| A1 | `lib/firebase_options.dart`, `lib/core/config/env_config.dart`, `lib/main.dart` | Firebase config loaded from `.env` / `--dart-define` |
| A2 | `.gitignore`, `android/app/google-services.json.example` | Real config gitignored; example template added |
| A3 | `.gitignore`, `.env.example` | `.env` excluded; example with placeholders added |
| A4 | `.gitignore` | Added `key.properties`, `*.jks`, `*.keystore` |
| A5 | `.gitignore` | Added `serviceAccount*.json` pattern |
| B1–B6 | `functions/src/security/rate_limiter.ts`, `callable_wrapper.ts`, `index.ts` | Sliding-window limits: auth 5/min, authenticated 60/min, costly 10/min; HTTP 429 via `resource-exhausted` + `retryAfter` |
| C1 | `firestore.rules` | User create forces `role == customer`; owner updates cannot change `role`/`email` |
| C2 | `firestore.rules` | Order create validates amounts, items, address; `paymentStatus: succeeded` requires verified payment doc |
| C3 | `firestore.rules` | Product schema validation on manager writes |
| C4 | `storage.rules` | Product uploads require manager+ role; MIME/size limits on all uploads |
| C5–C8 | `functions/src/security/validation.ts`, `index.ts` | Zod schemas on all callable inputs; strict field rejection |
| C9 | `lib/features/checkout/presentation/pages/checkout_page.dart`, `input_validators.dart` | Max-length validators on all checkout fields |
| C10 | `lib/features/search/presentation/pages/search_page.dart` | Query clamped to 80 chars |
| C11 | `lib/features/authentication/data/repositories/auth_repository_impl.dart` | Server-side name/phone validation before Firestore write |
| C12 | `lib/routes/app_router.dart` | Product ID format validated before navigation |
| D1 | `lib/routes/auth_redirect.dart`, `router_refresh.dart`, `app_router.dart` | Protected routes redirect to login; auth state refresh |
| D2 | `firestore.rules` | Admin operations enforced server-side |
| D3 | `lib/features/admin/presentation/pages/admin_dashboard_page.dart` | Seed restricted to admin (`manageUsers`) |
| D4 | `lib/features/payment/data/datasources/payment_remote_datasource.dart` | Local payment fallback gated to `kDebugMode` only |
| F1–F3 | `functions/src/http/security_headers.ts` | `apiHealth` endpoint with CSP, X-Frame-Options, nosniff, Referrer-Policy, Permissions-Policy, HSTS; explicit CORS allowlist via `ALLOWED_CORS_ORIGINS` |
| G1 | `lib/features/authentication/presentation/controllers/auth_controller.dart` | Uses `SafeErrorMessage.from()` |
| G2 | `lib/core/utils/exception_mapper.dart` | Generic default message |
| G3 | `lib/features/authentication/data/datasources/auth_remote_datasource.dart` | Generic default message |
| G4 | `lib/features/catalog/presentation/providers/catalog_seed_provider.dart` | Generic catalog error message |
| G5 | `lib/features/payment/presentation/providers/payment_provider.dart` | Generic payment error message |
| G6 | `lib/features/home/presentation/controllers/product_controller.dart` | Generic load error message |
| G7 | `lib/core/services/messaging_service.dart` | Debug log stripped of exception body |
| G8 | `scripts/seed_firestore.js` | Generic error log only |
| — | `lib/core/security/safe_error_message.dart`, `input_validators.dart` | Shared security utilities |
| — | `test/unit/security_test.dart` | Security unit tests |
| — | `README.md` | `.env` and `google-services.json` setup steps |

### MANUAL ACTION REQUIRED

1. **Rotate Firebase API keys** if `firebase_options.dart` or `google-services.json` were ever pushed to a public remote — keys exist in git history.
2. **Remove tracked secrets from git:**
   ```bash
   git rm --cached android/app/google-services.json
   git rm --cached lib/firebase_options.dart  # if old version had inline keys
   ```
3. **Create local `.env`** from `.env.example` with your Firebase project values.
4. **Copy** `android/app/google-services.json.example` → `google-services.json` (or download from Firebase Console).
5. **Deploy hardened rules and functions:**
   ```bash
   firebase deploy --only firestore:rules,storage:rules,functions
   ```
6. **Enable App Check enforcement** in Firebase Console for Auth, Firestore, Functions, Storage.
7. **Restrict API keys** in Google Cloud Console (Android app SHA-1, iOS bundle ID).
8. **Set `ALLOWED_CORS_ORIGINS`** in Cloud Functions environment if using `apiHealth` from a web dashboard.
9. **Redis (`REDIS_URL`)** for distributed rate limiting when running Functions on multiple instances.

### STILL AT RISK

| Item | Why |
|------|-----|
| Custom JWT 15 min / 7-day refresh | App uses **Firebase Auth ID tokens** (1 h expiry, SDK-managed refresh). Replacing this requires a custom auth backend. |
| CSRF protection | Not applicable to Firebase mobile SDK callables. Required only if HTTP cookie-based web API is added later. |
| HttpOnly / Secure cookies | Mobile app uses Firebase SDK tokens, not browser cookies. |
| In-memory rate limiter | Resets per Cloud Functions instance; use Redis for production multi-instance. |
| Firebase client API keys | Still present in the client binary at runtime (unavoidable for mobile Firebase). Mitigate with App Check + API key restrictions. |
| `npm audit` moderate vulnerabilities | Transitive deps in `functions/` — run `npm audit fix` and review before production deploy. |
| Local order cache | Orders in SharedPreferences are not encrypted; acceptable for portfolio, consider `flutter_secure_storage` for PII in production. |

---

## Verification

```bash
flutter analyze          # No issues
flutter test             # 26/26 passing
cd functions && npm run build   # TypeScript compiles
```

Deploy rules before testing role-escalation fixes:
```bash
firebase deploy --only firestore:rules,storage:rules
```
