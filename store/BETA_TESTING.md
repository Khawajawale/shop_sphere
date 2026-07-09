# Phase 13.3 — Beta Testing Guide

## Google Play — Internal Testing

Fastest way to test before production (up to 100 testers).

### Setup
1. Play Console → **Testing** → **Internal testing**
2. **Create new release** → upload `app-release.aab`
3. Add testers by email list
4. Share the opt-in link with testers

### Testing Track Progression
```
Internal testing (100 testers)
    ↓
Closed testing (invite-only, larger group)
    ↓
Open testing (public beta)
    ↓
Production
```

### Recommended Beta Duration
- **Internal:** 3–5 days — smoke test all flows
- **Closed:** 1–2 weeks — gather feedback, fix crashes
- **Production:** After Crashlytics shows stable crash-free rate (>99%)

---

## Apple TestFlight

### Internal Testing (up to 100)
1. Upload build via Xcode or `flutter build ipa`
2. App Store Connect → **TestFlight** → build appears after processing (~15 min)
3. Add internal testers (App Store Connect users)

### External Testing (up to 10,000)
1. Requires **Beta App Review** (usually 24–48 hours)
2. Add external tester group
3. Share public TestFlight link

---

## Beta Test Scenarios

Testers should verify:

| # | Flow | Expected |
|---|------|----------|
| 1 | Register + email verification | Account created, verification email sent |
| 2 | Login | Redirects to home |
| 3 | Browse home sections | Products load, categories filter |
| 4 | Search | Results appear |
| 5 | Product details | Images, add to cart, wishlist |
| 6 | Cart → Checkout | Order placed, cart cleared |
| 7 | Orders tab | Order appears in history |
| 8 | Wishlist | Add/remove favorites |
| 9 | Notifications | Push received (if FCM configured) |
| 10 | Profile → Edit | Name updates in Firebase |
| 11 | Logout | Returns to login |

---

## Reporting Issues

Ask testers to report:
- Device model & OS version
- Steps to reproduce
- Screenshots or screen recording
- Whether it happens on Wi-Fi and mobile data

Crash reports auto-capture in **Firebase Crashlytics**.

---

## Release Notes Template

See `store/BETA_RELEASE_NOTES_v1.0.0.md` for the first beta release notes.
