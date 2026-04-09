# Cross-Platform Mobile Development Strategy
**Environment:** Fedora Linux
**Cloud/Credits:** $150/mo Visual Studio Azure Credit
**Framework:** Flutter (Dart)

---

## 1. The Technology Stack
*   **Framework:** Flutter
    *   **Why:** Dart is a truly statically-typed, sound null-safe language. It completely avoids the quirks and unpredictability of dynamically typed languages (like JavaScript/React Native).
    *   **Rendering:** Flutter draws its own pixels (via Impeller/Canvas). A UI built on an Android emulator will look and behave almost identically on an iPhone.
*   **Local IDE:** VS Code or Android Studio on Fedora.
*   **Testing Setup (Current):** Local Android Emulator or physical Android device via USB.

## 2. The iOS/Mac Strategy: The "Big Assumption" Approach
Because Apple requires macOS to compile iOS apps and a $99/year Developer Account to test cloud-builds on a physical iPhone, the most cost-effective strategy is to **build entirely on Android first.**

*   **Do not use Azure credits for a Mac:** Azure macOS instances are "headless" (command-line only for CI/CD). Renting a GUI Mac in the cloud makes USB-passthrough to your physical iPhone (required for free testing) impossible due to latency/network restrictions.
*   **The Plan:** Code and test 100% of the app on Fedora using Android. Rely on Flutter's unified UI rendering. Delay paying the $99 Apple Developer fee or acquiring a Mac until the app is completely finished on Android.

## 3. How to Utilize the $150/mo Azure Credit
Since Azure isn't viable for bypassing the Mac requirement, use the $150 monthly credit to build a robust, scalable backend for your app:
*   **Azure App Service / Azure Functions:** Host your backend APIs.
*   **Azure SQL / Cosmos DB:** Store your application and user data.
*   **Azure Blob Storage:** Store user-uploaded files, images, or assets.
*   **Microsoft Entra ID B2C:** Manage user authentication (Login/Signup).
*   *(Later Phase)* **Azure DevOps:** Once you pay the $99 Apple fee, use Azure Pipelines (macOS agents) to automate your iOS `.ipa` builds and push them to Apple TestFlight.

---

## 4. The 5 iOS "Gotchas" (Crucial for Android-First Dev)
Because you are deferring iOS testing, you **must** code defensively to ensure the app doesn't break when it eventually runs on an iPhone. 

### I. The `SafeArea` Trap
*   **Issue:** iPhones have physical hardware cutouts (Dynamic Island / Notches) and bottom swipe bars.
*   **Fix:** Always wrap your main screen UI in Flutter's `SafeArea()` widget so your UI doesn't bleed into hardware elements.

### II. The Back Button Trap
*   **Issue:** Android has a system-level back gesture/button. iOS does not.
*   **Fix:** Ensure every screen in your app has a visual way to go back (e.g., using Flutter's `AppBar`, which automatically inserts a back arrow).

### III. The `Info.plist` Permissions Trap
*   **Issue:** When accessing native hardware (Camera, Location, Files), Android uses `AndroidManifest.xml`. iOS uses `Info.plist` but strictly requires a text explanation of *why* the permission is needed. Missing this causes instant app crashes on iOS.
*   **Fix:** Every time you install a hardware package, read the iOS setup instructions.

### IV. The Package Compatibility Rule
*   **Issue:** Some community packages on `pub.dev` are Android-only.
*   **Fix:** Before running `flutter pub add`, check the tags on the pub.dev page to ensure it explicitly supports **both** Android and iOS.

### V. The Apple Sign-In Mandate
*   **Issue:** If your app offers Google, Facebook, or any third-party social login, Apple's App Store guidelines legally require you to also offer "Sign in with Apple."
*   **Fix:** Plan your database and UI to support Apple Sign-In from day one if you use social auth.

---

## 5. The Step-by-Step Gameplan

1.  **Initialize Flutter:** Create the project on Fedora. 
2.  **Create an `iOS_TODO.txt` file:** Keep this in your project root. Every time you add a package that requires `Info.plist` updates (like the Camera or Location), write the required iOS configuration steps in this file so you don't forget them later.
3.  **Build the App:** Develop the UI, state management, and logic testing strictly on the Android Emulator.
4.  **Build the Backend:** Use your $150 Azure credits to wire up the database and APIs.
5.  **Finish Android First:** Get the app to 100% completion and polish on Android.
6.  **The iOS Pivot:** Once Android is finished, you have three choices to complete the iOS build:
    *   *Option A:* Pay the $99 Apple Developer fee, set up Azure DevOps CI/CD, and push builds to your iPhone via TestFlight.
    *   *Option B:* Borrow a friend's Mac or buy a cheap used Mac Mini to compile locally.
    *   *Option C (Hacker Route):* Spin up a local macOS Virtual Machine (via KVM/QEMU) on Fedora, pass your iPhone through via USB, and compile using Xcode's Free Provisioning.
7.  **Clear the TODOs:** Execute everything in your `iOS_TODO.txt` list on the Mac environment.
8.  **Publish:** Pay the $99 fee (mandatory for publishing) and release to the App Store and Google Play Store.