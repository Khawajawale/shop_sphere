# ShopSphere Portfolio Demo Guide

This project is optimized as a **portfolio showcase** for recruiters — demonstrating full-stack Flutter + Firebase architecture without requiring App Store / Play Store submission.

## What to highlight in interviews

| Capability | Where to see it |
|------------|-----------------|
| Clean Architecture + Riverpod | `lib/features/*` layered structure |
| Firestore catalog + local fallback | Home → products load from Firestore when seeded |
| Admin RBAC | Profile → Admin Dashboard (manager/admin role) |
| Cloud Functions | `functions/src/index.ts` — seed, payments, orders |
| Sandbox payments (Stripe-style) | Checkout → test cards + Cloud Function confirmation |
| Security rules | `firestore.rules` — products, orders, payments |
| Tests | `flutter test` |

## Quick demo flow (5 minutes)

1. **Run the app** — `flutter run`
2. **Register / sign in**
3. **Seed Firestore** (manager+ role) — Admin Dashboard → **Seed Firestore Catalog**
4. **Browse products** — Home reloads from Firestore
5. **Add to cart → Checkout**
6. **Pay with sandbox card** `4242 4242 4242 4242` (exp `12/30`, CVC `123`)
7. **View order** — Orders tab shows payment status + card last 4

## Firestore product seeding

Three ways to seed the same 15-product catalog (`assets/seed/products_catalog.json`):

### A. In-app (recommended for demos)

1. Assign yourself `manager` or `admin` role in Firestore `users/{uid}`
2. Open **Admin Dashboard** → **Seed Firestore Catalog**

### B. Node script

```bash
# Firebase CLI logged in or GOOGLE_APPLICATION_CREDENTIALS set
node scripts/seed_firestore.js
```

### C. Cloud Function (admin only)

```bash
cd functions && npm run build && firebase deploy --only functions:seedProducts
```

Then call `seedProducts` from an authenticated admin client.

## Sandbox payment integration

Stripe-style flow without real charges:

```
Checkout UI
    → createPaymentIntent (Cloud Function)
    → confirmSandboxPayment (Cloud Function)
    → placeOrder (Firestore + local cache)
```

### Test cards

| Card | Result |
|------|--------|
| `4242 4242 4242 4242` | Success |
| `4000 0000 0000 0002` | Declined |
| `4000 0000 0000 9995` | Insufficient funds |

Payment records are stored in Firestore `payments/{id}` (server-only writes).

**Offline / no Functions deployed:** the app automatically falls back to local sandbox simulation with the same test cards.

### Deploy payment functions

```bash
cd functions
npm install
npm run build
firebase deploy --only functions:createPaymentIntent,functions:confirmSandboxPayment
```

## Assigning admin role (one-time)

In Firebase Console → Firestore → `users/{your-uid}`:

```json
{
  "role": "admin"
}
```

## Architecture notes for recruiters

- **Single catalog source** — JSON asset shared by local fallback, seed script, and Cloud Functions
- **Payment layer** — isolated `lib/features/payment/` with repository pattern
- **Graceful degradation** — local catalog + local payment fallback when Firebase is unavailable
- **Production patterns** — security rules, callable functions, analytics, order sync

## Commands

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```
