# Feedback for Hương — Spec Review

## 1. Auto-logout 15 minutes (Admin ver 2) — SHOULD NOT BUILD

**Her spec says:** "user không thao tác trong vòng 15 phút sẽ tự out, yêu cầu phải đăng nhập lại"

**Problem:** This directly kills the retention loop that the entire app is built around.

- The app is designed for kids to open once a day, check in for 30 seconds, and close. If we log them out every 15 minutes, they need to remember a password every single time.
- A 13-year-old in school gets a push notification "Please log in again" every 15 minutes — the teacher sees it, tells them to delete the app, and we lose a user permanently.
- Kids will forget passwords, get frustrated, and uninstall. That destroys the notification → check-in → dashboard → parent pays funnel.
- No competing health app does this (Flo, Clue, Apple Health — none log you out).
- Binance does it because they hold money. We hold check-in emotions. The threat model is completely different.

**What I'll build instead:**
- **Online/offline status tracking** (needed for notification routing: push vs in-app) — this is what she actually needs
- **Standard 30-day token expiry** with refresh token — normal mobile app security
- Optional: biometric/PIN unlock if she wants a security layer without the friction of full re-login
