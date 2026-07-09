# Phase 13.2 — Store Submission Guide

## Google Play Store

### 1. Create Developer Account
- Go to [Google Play Console](https://play.google.com/console)
- Pay one-time $25 registration fee
- Complete identity verification

### 2. Create App
- **Create app** → Name: **ShopSphere**
- Default language: English
- App or game: App
- Free or paid: Free

### 3. Set Up App Signing
- Choose **Google Play App Signing** (recommended)
- Upload your upload key certificate:
  ```bash
  keytool -export -rfc -alias upload -file upload_certificate.pem -keystore android/upload-keystore.jks
  ```

### 4. Upload Release
- **Production** → **Create new release**
- Upload `app-release.aab` from `build/app/outputs/bundle/release/`
- Release name: `1.0.0 (1)`
- Copy release notes from `store/BETA_RELEASE_NOTES_v1.0.0.md`

### 5. Store Listing
Use content from `store/STORE_LISTING.md`:
- Short description (80 chars)
- Full description
- Screenshots (min 4 phone screenshots)
- Feature graphic (1024×500)
- App icon (512×512)

### 6. Required Policies
- **Privacy policy URL** — host `store/PRIVACY_POLICY.md` at a public URL
- **Data safety form** — declare:
  - Email, name (account creation)
  - Purchase history (orders)
  - App interactions (Analytics)
  - Device identifiers (FCM token, App Check)
- **Content rating** — complete IARC questionnaire
- **Target audience** — 13+ recommended

### 7. Submit for Review
- Complete all checklist items in Play Console
- Send for review (typically 1–7 days)

---

## Apple App Store

### 1. Apple Developer Program
- Enroll at [developer.apple.com](https://developer.apple.com) ($99/year)

### 2. App Store Connect
- **My Apps** → **+** → **New App**
- Platform: iOS
- Name: ShopSphere
- Bundle ID: `com.example.shopSphere` (or your production ID)
- SKU: `shopsphere-ios-001`

### 3. Build & Upload
On macOS with Xcode:
```bash
flutter build ipa --release
```

Upload via:
- **Xcode** → Window → Organizer → Distribute App
- Or **Transporter** app with the `.ipa` file
- Or `xcrun altool --upload-app`

### 4. TestFlight (see BETA_TESTING.md)
- Add internal testers (up to 100)
- Submit for Beta App Review if external testing

### 5. App Store Listing
- Subtitle: Premium Shopping, Simplified
- Description from `STORE_LISTING.md`
- Keywords: shopping,ecommerce,store,fashion,electronics
- Screenshots per device size (6.7", 6.5", 5.5", iPad)
- Privacy policy URL
- Support URL

### 6. App Privacy
Declare data collection matching Firebase usage:
- Contact info (email, name)
- Purchases
- Identifiers (user ID, device token)
- Usage data (Analytics)

### 7. Submit for Review
- Select the uploaded build
- Answer export compliance (uses encryption → Yes, exempt)
- Submit

---

## Post-Submission Checklist

- [ ] Firebase production rules deployed
- [ ] App Check production providers enabled (not debug)
- [ ] Remote Config production values set
- [ ] Crashlytics receiving events
- [ ] FCM push notifications tested on production build
- [ ] Support email monitored: support@shopsphere.app
