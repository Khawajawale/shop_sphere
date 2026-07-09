# Phase 13.4 — Production Release Monitoring Runbook

## Dashboards to Monitor Daily (First 2 Weeks)

### Firebase Crashlytics
**Console:** Firebase → Crashlytics

| Metric | Target | Action if breached |
|--------|--------|-------------------|
| Crash-free users | > 99% | Hotfix release |
| Crash-free sessions | > 99.5% | Investigate top crash |
| New fatal issues | 0 | Fix within 24h |

### Firebase Analytics
**Console:** Firebase → Analytics → Events

Custom events logged by ShopSphere:
| Event | When |
|-------|------|
| `app_open` | Every cold start |
| `session_start` | First launch per session |
| `session_ready` | User reaches home screen |
| `app_updated` | Version changed since last launch |

Standard events:
- `login`, `sign_up`, `view_item`, `add_to_cart`, `search`, `purchase`

### Firebase Performance
**Console:** Firebase → Performance

| Trace | Target |
|-------|--------|
| `load_home_products` | < 3 seconds (p95) |

### Remote Config
**Console:** Firebase → Remote Config

Monitor parameter fetch success. If `maintenance_mode` is accidentally `true`, users see maintenance screen.

---

## Alert Setup (Recommended)

### Crashlytics Email Alerts
1. Firebase Console → Crashlytics → Settings
2. Enable email alerts for new fatal issues
3. Add team email addresses

### Google Play Console
- **Android vitals** → monitor ANR rate (< 0.5%) and crash rate
- Set up email notifications for vitals regressions

### App Store Connect
- **Xcode Organizer** → Crashes (if using Apple crash reports)
- **Metrics** → Crashes, Hangs

---

## Incident Response Playbook

### P0 — App Crashes on Launch
1. Check Crashlytics for stack trace
2. If Remote Config issue → set `maintenance_mode: false`
3. If code bug → hotfix branch → `version: 1.0.1+2` → emergency release

### P1 — Checkout / Orders Broken
1. Check Firestore rules and Cloud Functions logs
2. Verify orders collection permissions
3. Roll back Firestore rules if needed: `firebase deploy --only firestore:rules`

### P2 — Slow Home Load
1. Check Performance trace `load_home_products`
2. Verify Firestore indexes are built
3. Check if local fallback is activating (empty Firestore)

---

## Weekly Review Checklist

- [ ] Crash-free rate above 99%
- [ ] No unresolved P0/P1 crashes
- [ ] `load_home_products` p95 under 3s
- [ ] FCM delivery rate healthy
- [ ] Play Console / App Store ratings reviewed
- [ ] User feedback addressed or triaged

---

## Version Upgrade Tracking

The app logs `app_updated` analytics event when version changes.
Check Analytics → `app_updated` to see adoption of new releases.

Current version: see `pubspec.yaml` → `version: X.Y.Z+BUILD`
