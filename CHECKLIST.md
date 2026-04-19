# SSCare — Development Environment Checklist

> Flutter + Dart on Windows, Android first, VS Code as IDE

---

## 1. System Prerequisites

- [ ] **Windows 10/11** (64-bit)
- [ ] **Git** installed → `git --version`
- [ ] **PowerShell 7+** or Windows Terminal

---

## 2. Flutter SDK

- [ ] Download Flutter SDK: https://docs.flutter.dev/get-started/install/windows/mobile
- [ ] Extract to `C:\flutter` (avoid paths with spaces or special chars)
- [ ] Add `C:\flutter\bin` to system PATH
- [ ] Verify: `flutter --version` → should show Flutter 3.x / Dart 3.x
- [ ] Run: `flutter doctor` → check for issues

---

## 3. Android Toolchain

- [ ] **Android Studio** installed (needed for SDK manager + emulator, even if coding in VS Code)
  - Download: https://developer.android.com/studio
  - During install: check "Android SDK", "Android SDK Platform", "Android Virtual Device"
- [ ] **Android SDK** (via Android Studio → SDK Manager):
  - [ ] Android SDK Platform 34 (Android 14)
  - [ ] Android SDK Build-Tools 34.x
  - [ ] Android SDK Command-line Tools
  - [ ] Android Emulator
  - [ ] Android SDK Platform-Tools
- [ ] Set `ANDROID_HOME` environment variable → typically `C:\Users\<you>\AppData\Local\Android\Sdk`
- [ ] Add to PATH: `%ANDROID_HOME%\platform-tools`
- [ ] Accept licenses: `flutter doctor --android-licenses`

---

## 4. Android Emulator

- [ ] **Enable hardware acceleration:**
  - Intel CPU → enable Intel HAXM (via SDK Manager → SDK Tools)
  - AMD CPU → enable Windows Hypervisor Platform (Windows Features)
- [ ] **Create AVD** (Android Virtual Device):
  - Open Android Studio → Device Manager → Create Device
  - Recommended: Pixel 7 / API 34 / x86_64 system image
  - RAM: 2048 MB minimum
- [ ] Test emulator launch: Android Studio → Device Manager → Play button
- [ ] Verify Flutter sees it: `flutter devices` → should list emulator

---

## 5. VS Code Setup

- [ ] **VS Code** installed (latest stable)
- [ ] **Extensions to install:**
  - [ ] `Dart-Code.dart-code` — Dart language support
  - [ ] `Dart-Code.flutter` — Flutter tools (run, debug, hot reload)
  - [ ] `nash.awesome-flutter-snippets` — Flutter code snippets (optional)
  - [ ] `jeroen-meijer.pubspec-assist` — pubspec.yaml helper (optional)
- [ ] **Verify integration:**
  - `Ctrl+Shift+P` → "Flutter: Select Device" → should show emulator/device
  - `Ctrl+Shift+P` → "Flutter: New Project" → should scaffold project

---

## 6. Create Flutter Project

```powershell
cd C:\path\to\workspace
flutter create --org com.sscare --project-name sscare .
```

- [ ] Verify: `flutter run` → app launches on emulator with default counter app
- [ ] Hot reload works: edit `lib/main.dart` → save → see changes instantly

---

## 7. Key Dependencies (pubspec.yaml)

Add these after project creation:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.5.0      # State management
  go_router: ^14.0.0             # Navigation
  dio: ^5.4.0                    # HTTP client
  flutter_secure_storage: ^9.0.0 # Encrypted token storage
  hive_flutter: ^1.1.0           # Local cache
  json_annotation: ^4.9.0        # JSON serialization
  intl: ^0.19.0                  # Date formatting (Vietnamese)
  qr_flutter: ^4.1.0             # QR code generation
  firebase_messaging: ^15.0.0    # Push notifications
  firebase_core: ^3.0.0          # Firebase base

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.0
  json_serializable: ^6.8.0
  flutter_lints: ^4.0.0
  mockito: ^5.4.0
```

- [ ] Run: `flutter pub get`
- [ ] Run: `flutter analyze` → 0 issues

---

## 8. Firebase Setup (for FCM)

- [ ] Create Firebase project at https://console.firebase.google.com
- [ ] Add Android app: package name `com.sscare.sscare`
- [ ] Download `google-services.json` → place in `android/app/`
- [ ] Add Firebase plugins to `android/build.gradle` and `android/app/build.gradle`
- [ ] Verify: `flutter run` still works after Firebase integration

---

## 9. Azure Backend Prerequisites (for later)

- [ ] Azure account with active subscription
- [ ] .NET 8 SDK installed → `dotnet --version`
- [ ] Azure CLI installed → `az --version`
- [ ] VS Code extensions:
  - [ ] `ms-dotnettools.csharp` — C# support
  - [ ] `ms-azuretools.vscode-azurefunctions` — Azure Functions

---

## 10. Git Setup

- [ ] Repository initialized: `git init`
- [ ] `.gitignore` covers: `build/`, `.dart_tool/`, `.flutter-plugins`, `*.g.dart`, `.env`
- [ ] First commit: `git add -A && git commit -m "Initial Flutter project scaffold"`

---

## 11. Verification Checklist

Run these commands and confirm all pass:

```powershell
flutter doctor -v          # All green checks
flutter devices            # At least 1 device/emulator listed
flutter analyze            # No issues
flutter test               # Default tests pass
flutter run                # App launches on emulator
```

---

## Quick Reference

| Command | Purpose |
|---------|---------|
| `flutter run` | Launch app on connected device/emulator |
| `flutter run -d chrome` | Launch on Chrome (web debug) |
| `r` (in terminal) | Hot reload |
| `R` (in terminal) | Hot restart |
| `flutter pub get` | Install dependencies |
| `flutter pub run build_runner build` | Generate JSON serialization code |
| `flutter analyze` | Static analysis |
| `flutter test` | Run all tests |
| `flutter build apk --release` | Build release APK |
