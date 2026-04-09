# App Publishing & Launch Strategy
**Target Platforms:** Google Play Store (Android) & Apple App Store (iOS)
**Framework:** Flutter
**Developer Location:** Vietnam

---

## 1. The 3rd-Party App Store Situation
*   **Ignore it for now.** Apple's new rules allowing alternative app stores (due to the Digital Markets Act) currently only apply to users physically in the **European Union**. 
*   For a global or Asia/US release, you must use the official Apple App Store.

---

## 2. Google Play Store (Android)
*   **Cost:** $25 (One-time fee, lifetime account).
*   **Technical Format:** You must upload an **AAB (Android App Bundle)** file (`flutter build appbundle`). Do not upload an APK.
*   **The Massive Caveat (The 20-Tester Rule):** New personal developer accounts are blocked from public publishing immediately. You **must** run a Closed Test with **20 real people** who keep the app installed for **14 consecutive days** before you can apply for a production release.
*   **Processing Time:** Expect up to **7 days** for the initial bot/human review. Future updates usually take 2 to 24 hours.

---

## 3. Apple App Store (iOS)
*   **Cost:** $99 / Year (If you stop paying, your app is removed).
*   **Technical Format:** You must upload an **IPA** file. Since you are on Linux, you will configure an Azure DevOps Pipeline to build the IPA and push it to App Store Connect using an API Key.
*   **The Massive Caveats (Human Review):**
    *   **No "Beta" UI:** Any dummy text (Lorem Ipsum), broken links, or "Coming Soon" buttons will result in instant rejection.
    *   **The Apple Tax:** If you sell digital goods or premium features, you *must* use Apple's In-App Purchases (they take a 15-30% cut). You cannot redirect users to Stripe or external websites for digital unlocks.
    *   **Privacy File:** You must include a `PrivacyInfo.xcprivacy` file detailing all data your app collects.
*   **Processing Time:** Usually **24 to 48 hours**. **Expect to be rejected at least once** on your first submission while you fix minor UI or policy issues.

---

## 4. The 4-Week "Day-1" Launch Timeline
You cannot finish coding on a Friday and launch on Saturday. Start this process a month before your target Launch Day.

### Weeks 4 & 3: Assets & Android Testing
*   [ ] **Privacy Policy:** Create a hosted web page with your privacy policy (GitHub Pages works well). Both Apple and Google mandate this.
*   [ ] **Screenshots:** Generate 4-5 high-quality, framed screenshots for both Android and iOS (use tools like *appmockup.com*).
*   [ ] **App Icon:** Prepare a high-res `1024x1024` icon with square corners (the stores will round/mask it automatically).
*   [ ] **Start the Google Clock:** Gather 20 testers, push your AAB to the Google Play Closed Testing track, and start the mandatory 14-day clock.

### Week 2: The Apple Gauntlet
*   [ ] **Push to TestFlight:** Use your Azure Pipeline to push the iOS build into Apple TestFlight.
*   [ ] **Physical Device Test:** Test the app on your physical iPhone (Check `SafeArea`, Back Buttons, and `Info.plist` permissions).
*   [ ] **Submit for Review:** Submit to the Apple App Store. 
*   [ ] **Handle Rejection:** Be prepared to fix whatever the Apple reviewer complains about and resubmit.

### Week 1: Final Approvals
*   [ ] **Google Production:** Your 14-day test finishes. Click "Apply for Production" and wait for Google's ~7-day review.
*   [ ] **Hold the Apple Release:** Once Apple approves the app, ensure your release setting in App Store Connect is set to **"Manually release this version"** so it stays hidden until Android is ready.

### Day 1: Launch Day
*   [ ] Both Android and Apple versions are approved.
*   [ ] Click "Release" on both platforms. 
*   [ ] Within 24 hours, your app will propagate and be live globally!

---

## 5. Vietnam-Specific Financial Setup
If you plan to charge money for your app (paid app or in-app purchases):
*   **Bank Matching:** The name on your Apple/Google Developer account **must strictly match** your local Vietnamese bank account name.
*   **Taxes:** Vietnam requires foreign contractor taxes to be withheld. Apple and Google will handle this automatically on your behalf, but you must ensure your tax ID and banking details are completely accurate in their respective payout portals to avoid blocked transfers.