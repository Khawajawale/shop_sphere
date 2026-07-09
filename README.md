# ShopSphere

A production-quality Flutter e-commerce application built with Clean Architecture, Riverpod, and Firebase.

## Portfolio Note (Important)

This repository is a **recruiter-facing portfolio demo**.

- **No store publishing required**: this app is not intended for Play/App Store submission.
- **Full-stack patterns included**: Firestore rules, Cloud Functions code, admin RBAC, and a sandbox payment flow demonstrate production architecture.
- **Demo-first design**: the app includes **local fallbacks** (catalog + sandbox payment) so it can be reviewed end-to-end without paid Firebase features enabled.

## Features

- Premium Material 3 UI inspired by leading retail apps
- Firebase Authentication (register, login, email verification, password reset)
- Product catalog with Firestore + local fallback catalog
- Featured products with category filtering, shimmer, and empty states
- Product details, wishlist, cart, checkout, and order history
- Search, notifications, profile management
- Role-based admin panel (Customer, Staff, Manager, Admin)
- Firestore & Storage security rules

## Tech Stack

- Flutter / Dart
- Riverpod
- go_router
- Firebase (Auth, Firestore, Storage, Analytics, Crashlytics, Messaging)
- cached_network_image, shimmer, google_fonts

## Getting Started

1. Copy environment config:
   ```bash
   cp .env.example .env
   # Fill in Firebase values from Firebase Console
   ```
2. Copy Android Firebase config (gitignored):
   ```bash
   cp android/app/google-services.json.example android/app/google-services.json
   ```
3. Install and run:
   ```bash
   flutter pub get
   flutter run
   ```

### What works locally (no paid Firebase plan needed)

- **Browse catalog** (Firestore if seeded, otherwise bundled JSON fallback)
- **Cart → Checkout → Sandbox payment** (local simulation when Functions aren’t deployed)
- **Orders** (local cache + Firestore when available)
- **Admin dashboard UI** (RBAC enforced by Firestore rules)

## Testing

```bash
# Unit & widget tests
flutter test

# Integration tests (requires device/emulator)
flutter test integration_test
```

## Portfolio Demo (Phase 14)

See **`docs/PORTFOLIO_DEMO.md`** for recruiter demo flow, Firestore seeding, and sandbox payment test cards.

```bash
flutter run
# Admin Dashboard → Seed Firestore Catalog
# Checkout → pay with 4242 4242 4242 4242
```

## Store Release (Phase 13 — optional)

### Generate signed builds

1. Copy `android/key.properties.example` → `android/key.properties`
2. Create upload keystore (see `store/RELEASE_BUILDS.md`)
3. Run release build:

```powershell
.\scripts\build_release.ps1
```

### Submission guides

| Document | Purpose |
|----------|---------|
| `store/RELEASE_BUILDS.md` | Keystore & signed build steps |
| `store/RELEASE_SUBMISSION.md` | Play Store & App Store upload |
| `store/BETA_TESTING.md` | Internal testing & TestFlight |
| `store/MONITORING_RUNBOOK.md` | Post-launch monitoring |
| `store/BETA_RELEASE_NOTES_v1.0.0.md` | First release notes |

### CI/CD

Push a version tag to trigger release build:
```bash
git tag v1.0.0
git push origin v1.0.0
```

Configure GitHub secrets: `KEYSTORE_BASE64`, `KEY_ALIAS`, `KEY_PASSWORD`, `STORE_PASSWORD`

## Store Release Assets

See the `store/` folder for:
- `STORE_LISTING.md` — Play Store / App Store copy
- `PRIVACY_POLICY.md` — Privacy policy template
- `ACCESSIBILITY_AUDIT.md` — Accessibility compliance notes
- `PERFORMANCE_GUIDE.md` — Profiling & optimization guide
- `RELEASE_BUILDS.md` — Signed build instructions
- `RELEASE_SUBMISSION.md` — Store upload guide
- `BETA_TESTING.md` — Beta testing guide
- `MONITORING_RUNBOOK.md` — Production monitoring

## Firebase Setup

1. Ensure `lib/firebase_options.dart` and `android/app/google-services.json` are configured.
2. Deploy security rules and Cloud Functions:

```bash
firebase deploy --only firestore:rules,storage:rules,firestore:indexes,functions
```

### Firebase deployment constraints (student-friendly)

Some Firebase features may require extra project setup that can involve billing verification:

- **Cloud Functions deployment** may require the **Blaze plan** (even if you stay within the free tier limits).
- **Firebase Storage rules deployment** requires Firebase Storage to be initialized for the project.

This repo is designed so recruiters can still evaluate architecture **without** completing those paid/verified steps.

3. For App Check debug builds, register the debug token in Firebase Console (printed in logcat on first run).
4. Configure Remote Config parameters in Firebase Console (or use defaults):
   - `flash_sale_enabled`, `free_shipping_threshold`, `maintenance_mode`, `promo_banner_text`
5. To enable admin access, set `role` on a user document in Firestore:
   - `customer` (default)
   - `staff`
   - `manager`
   - `admin`

## Security

See **[docs/SECURITY_AUDIT.md](docs/SECURITY_AUDIT.md)** for the full audit report, fixes, and manual action items.

Key setup:
- Copy `.env.example` → `.env` (never commit)
- Deploy `firestore.rules`, `storage.rules`, and Cloud Functions after pulling

## Architecture

ShopSphere is a **full-stack Flutter + Firebase** e-commerce app. The client follows **Clean Architecture** with **Riverpod** for state management. Business logic never lives in widgets; Firebase is accessed only through repository and datasource layers.

For the full development guide and roadmap, see [SHOPSPHERE_AI_GUIDE.md](SHOPSPHERE_AI_GUIDE.md).

### Full-stack overview

```mermaid
flowchart TB
  subgraph Client["Flutter Client (Dart)"]
    UI["Presentation Layer\nPages · Widgets · go_router"]
    Riverpod["Riverpod\nControllers · Providers · State"]
    Domain["Domain Layer\nEntities · Repositories · Use Cases"]
    Data["Data Layer\nRepository Impl · Datasources · Mappers"]
  end

  subgraph Firebase["Firebase Backend"]
    Auth["Authentication"]
  Firestore["Cloud Firestore\nproducts · orders · users · payments"]
    Functions["Cloud Functions\ncreatePaymentIntent · confirmSandboxPayment · seedProducts"]
    FCM["Cloud Messaging"]
    RC["Remote Config"]
    Analytics["Analytics · Crashlytics · Performance"]
  end

  subgraph Local["Local / Fallback"]
    JSON["Bundled Catalog JSON\nassets/seed/products_catalog.json"]
    Prefs["SharedPreferences\norders · wishlist · cart cache"]
  end

  UI --> Riverpod
  Riverpod --> Domain
  Domain --> Data
  Data --> Auth
  Data --> Firestore
  Data --> Functions
  Data --> JSON
  Data --> Prefs
  Functions --> Firestore
  FCM --> UI
  RC --> Riverpod
  Analytics --> Firebase
```

| Layer | Responsibility | Examples |
|-------|----------------|----------|
| **Presentation** | UI, navigation, user input | `checkout_page.dart`, `product_card.dart`, `app_router.dart` |
| **State (Riverpod)** | App state, orchestration, derived values | `productControllerProvider`, `cartControllerProvider`, `paymentControllerProvider` |
| **Domain** | Business contracts, entities | `Product`, `OrderEntity`, `PaymentRepository` |
| **Data** | Firebase I/O, mapping, fallbacks | `ProductRepositoryImpl`, `PaymentRemoteDataSource`, `CatalogSeedingService` |
| **Backend** | Auth, persistence, server logic | Firestore rules, callable Cloud Functions |

### State management (Riverpod)

State is centralized in **providers** and **controllers** (`StateNotifier`). Widgets are declarative: they `watch` state and call controller methods for actions.

```mermaid
flowchart LR
  subgraph Widgets
    W1["HomePage"]
    W2["CartPage"]
    W3["CheckoutPage"]
    W4["AdminDashboard"]
  end

  subgraph Controllers["StateNotifier Controllers"]
    PC["ProductController"]
    CC["CartController"]
    PayC["PaymentController"]
    OC["OrdersController"]
    AC["AuthController"]
    SeedC["CatalogSeedController"]
  end

  subgraph Derived["Derived Providers"]
    Total["cartTotalPriceProvider"]
    Count["cartItemCountProvider"]
    Config["remoteConfigProvider"]
  end

  subgraph Repos["Repositories / Services"]
    PR["ProductRepository"]
    PayR["PaymentRepository"]
    OR["OrdersRemoteDataSource"]
    CS["CatalogSeedingService"]
  end

  W1 -->|watch| PC
  W2 -->|watch| CC
  W2 -->|watch| Total
  W3 -->|watch| CC
  W3 -->|watch| PayC
  W3 -->|watch| Config
  W4 -->|watch| SeedC

  PC --> PR
  PayC --> PayR
  OC --> OR
  SeedC --> CS
  CC --> Total
  CC --> Count
```

**Patterns used**

- `StateNotifierProvider` — mutable feature state (cart, orders, products, auth)
- `Provider` — repositories, datasources, and inexpensive derived values
- `ref.watch` in `build` — reactive UI updates
- `ref.read` in callbacks — one-off actions (place order, seed catalog, login)

### API & data flow

#### Product catalog (Firestore + local fallback)

```mermaid
sequenceDiagram
  participant UI as HomePage
  participant PC as ProductController
  participant Repo as ProductRepositoryImpl
  participant Remote as ProductRemoteDataSource
  participant FS as Cloud Firestore
  participant Local as ProductLocalDataSource
  participant JSON as products_catalog.json

  UI->>PC: loadHomeProducts()
  PC->>Repo: getFeaturedProducts() / getAllProducts()
  Repo->>Remote: query products collection
  Remote->>FS: get / where featured
  alt Firestore has documents
    FS-->>Remote: product documents
    Remote-->>Repo: QuerySnapshot
    Repo-->>PC: List Product
  else Empty or offline
    Repo->>Local: getFeaturedProducts()
    Local->>JSON: load bundled catalog
    JSON-->>Local: 15 products
    Local-->>Repo: List Product
    Repo-->>PC: List Product
  end
  PC-->>UI: ProductState (rebuild)
```

#### Checkout & sandbox payment (Cloud Functions + fallback)

```mermaid
sequenceDiagram
  participant UI as CheckoutPage
  participant PayC as PaymentController
  participant PayR as PaymentRepository
  participant CF as Cloud Functions
  participant FS as Firestore payments
  participant OC as OrdersController
  participant Orders as Firestore orders

  UI->>PayC: processCheckoutPayment(amount, card)
  PayC->>PayR: createPaymentIntent()
  PayR->>CF: createPaymentIntent
  CF->>FS: write payment doc (requires_payment_method)
  CF-->>PayR: paymentId + clientSecret
  PayR-->>PayC: PaymentIntent

  PayC->>PayR: confirmSandboxPayment()
  PayR->>CF: confirmSandboxPayment
  CF->>CF: validate sandbox test card
  CF->>FS: update status succeeded/failed
  CF-->>PayR: PaymentResult
  PayR-->>PayC: PaymentResult

  alt Payment succeeded
    PayC-->>UI: success
    UI->>OC: placeOrder(items, paymentId, cardLast4)
    OC->>Orders: createOrder document
    OC->>OC: persist to SharedPreferences
  else Payment failed
    PayC-->>UI: show decline reason
  end
```

> If Cloud Functions are not deployed, `PaymentRemoteDataSource` falls back to **local sandbox simulation** using the same test cards — so checkout still works in portfolio demos.

#### Firestore catalog seeding (admin)

```mermaid
flowchart LR
  Admin["Admin Dashboard"] --> SeedC["CatalogSeedController"]
  SeedC --> Svc["CatalogSeedingService"]
  Svc --> JSON["products_catalog.json"]
  Svc -->|batch write| FS["Firestore products"]
  SeedC --> PC["ProductController.loadHomeProducts()"]
  PC --> UI["Home reloads from Firestore"]
```

### Security & backend contracts

- **Firestore rules** — role-based access (`customer` → `admin`); payments are server-write only
- **Callable Functions** — auth-checked server logic for payments, product seeding, order status
- **App Check + Remote Config** — production hardening and runtime feature flags

### Project structure

```
lib/
├── core/                 # Theme, RBAC, Firebase bootstrap, analytics, shared widgets
│   ├── auth/             # Roles, permissions
│   ├── services/         # Firebase, messaging, remote config, performance
│   └── providers/        # App-wide Riverpod providers
├── features/             # Feature modules (each: data / domain / presentation)
│   ├── authentication/
│   ├── home/             # Catalog, featured products, categories
│   ├── catalog/          # Firestore seeding
│   ├── payment/          # Sandbox payment (Clean Architecture)
│   ├── cart/ · checkout/ · orders/
│   ├── wishlist/ · search/ · profile/ · admin/
│   └── ...
├── routes/               # go_router shell + route definitions
└── main.dart

functions/src/            # Cloud Functions (TypeScript)
├── index.ts              # Callable exports + Firestore triggers
├── payments/             # Sandbox payment logic
└── seed/                 # Canonical product seed data

assets/seed/              # Shared product catalog JSON
firestore.rules           # Security rules
```

