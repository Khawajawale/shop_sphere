# Phase 13.1 — Generate Signed Release Builds

## Prerequisites

- Flutter SDK (stable channel)
- Android Studio + SDK
- Java 17
- For iOS: macOS, Xcode, Apple Developer account ($99/year)

## Step 1: Create Android Upload Keystore

```bash
keytool -genkey -v \
  -keystore android/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

Store the keystore and passwords securely. **If lost, you cannot update the app on Play Store.**

## Step 2: Configure Signing

```bash
cp android/key.properties.example android/key.properties
```

Edit `android/key.properties` with your passwords and keystore path.

## Step 3: Build Release Artifacts

**Windows:**
```powershell
.\scripts\build_release.ps1
```

**macOS / Linux:**
```bash
chmod +x scripts/build_release.sh
./scripts/build_release.sh
```

**Manual commands:**
```bash
flutter test
flutter build appbundle --release   # Play Store upload
flutter build apk --release         # Direct APK distribution
flutter build ipa --release         # App Store (macOS only)
```

## Output Locations

| Artifact | Path |
|----------|------|
| Android AAB | `build/app/outputs/bundle/release/app-release.aab` |
| Android APK | `build/app/outputs/flutter-apk/app-release.apk` |
| iOS IPA | `build/ios/ipa/*.ipa` |

## Before First Store Upload

### Change Application ID (recommended)

Current ID: `com.example.shop_sphere`

For production, migrate to `com.shopsphere.app`:

1. Firebase Console → Add Android app with new package name
2. Download new `google-services.json` → `android/app/`
3. Run `flutterfire configure`
4. Update `applicationId` in `android/app/build.gradle.kts`
5. Update iOS bundle ID in Xcode → `com.shopsphere.app`

> You cannot change the Android application ID after publishing to Play Store.

## Version Bumping

Edit `pubspec.yaml`:
```yaml
version: 1.0.1+2   # versionName+versionCode
```

- **versionName** (`1.0.1`) — user-visible version
- **versionCode** (`2`) — must increment every Play Store upload

## Release Build Features Enabled

- R8 code shrinking & obfuscation
- Resource shrinking
- ProGuard rules for Flutter + Firebase
- Release signing (when `key.properties` exists)
