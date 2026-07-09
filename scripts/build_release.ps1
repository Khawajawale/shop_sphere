# ShopSphere release build script (Windows PowerShell)
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

Write-Host "==> Running tests..." -ForegroundColor Cyan
flutter test
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "==> Building Android App Bundle (release)..." -ForegroundColor Cyan
flutter build appbundle --release
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "==> Building Android APK (release)..." -ForegroundColor Cyan
flutter build apk --release
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host ""
Write-Host "Build complete!" -ForegroundColor Green
Write-Host "  AAB: build\app\outputs\bundle\release\app-release.aab"
Write-Host "  APK: build\app\outputs\flutter-apk\app-release.apk"
Write-Host ""
Write-Host "For iOS (requires macOS + Xcode):"
Write-Host "  flutter build ipa --release"
