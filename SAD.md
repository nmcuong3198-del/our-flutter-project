# SSCare — Software Architecture Document (SAD)

> Version 2.0 — April 2026
> **Scope:** Parent-only app + Admin CMS
> Pattern: MVVM + Repository, Riverpod, Flutter/Dart

---

## 1. MVVM + Repository Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│  VIEW LAYER — Flutter Widgets, ZERO business logic                  │
│  Reads state via ref.watch(), dispatches actions to ViewModel       │
└──────────────────────────────┬──────────────────────────────────────┘
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│  VIEWMODEL LAYER — Riverpod StateNotifier / AsyncNotifier           │
│  UI state, business rules, calls Repositories                       │
└──────────────────────────────┬──────────────────────────────────────┘
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│  REPOSITORY LAYER — single source of truth                          │
│  Local (Hive) vs remote (Dio), sync queue, DTO → Model mapping     │
└──────────────────────────────┬──────────────────────────────────────┘
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│  DATA SOURCES: Dio (REST API) │ Hive (cache) │ SecureStorage (JWT)  │
└─────────────────────────────────────────────────────────────────────┘
```

### Cross-Cutting Services
| Service | Responsibility |
|---------|---------------|
| AuthService | Token mgmt, session state |
| NotificationService | FCM handler, deep link nav |
| ConnectivityService | Online/offline detection, sync trigger |
| OnboardingService | Drip campaign state machine |
| AnalyticsService | Event tracking |

---

## 2. Project Structure

```
lib/
├── main.dart / app.dart
├── core/
│   ├── constants/  theme/  network/  storage/  utils/
│   ├── notifications/
│   │   ├── notification_service.dart     # FCM init
│   │   ├── notification_handler.dart     # Foreground/background
│   │   ├── notification_router.dart      # Deep link → GoRouter
│   │   └── notification_channel.dart     # Android channels
│   └── services/
│       ├── auth_service.dart
│       ├── onboarding_service.dart
│       └── analytics_service.dart
├── features/
│   ├── auth/          { models/ repositories/ viewmodels/ views/ }
│   ├── children/      { models/ repositories/ viewmodels/ views/ }
│   ├── checkin/       { models/ repositories/ viewmodels/ views/ }
│   ├── measurements/  { models/ repositories/ viewmodels/ views/ }
│   ├── cycle/         { models/ repositories/ viewmodels/ views/ }
│   ├── practice/      { models/ repositories/ viewmodels/ views/ }
│   ├── library/       { models/ repositories/ viewmodels/ views/ }
│   ├── reports/       { models/ repositories/ viewmodels/ views/ }
│   ├── reminders/     { models/ repositories/ viewmodels/ views/ }
│   ├── notifications/ { models/ repositories/ viewmodels/ views/ }
│   ├── settings/      { models/ repositories/ viewmodels/ views/ }
│   └── onboarding/    { viewmodels/ views/ }
├── routing/
│   ├── app_router.dart
│   ├── route_guards.dart
│   └── notification_routes.dart
└── shared/  { widgets/ extensions/ mixins/ }
```

---

## 3. Notification Architecture

### 3.1 Types
```dart
enum NotificationType {
  checkinNudge,         // escalation tiers 1-7
  cyclePrediction,
  calendarWeeklyDigest,
  calendarDayReminder,
  practiceWeeklyNudge,
  microLearning,
  coachingTip,
  newArticleContent,
  onboardingDrip,
  packageExpiry,
  offerExpiry,
  adminBroadcast,
}
```

### 3.2 Flow
```
Azure Functions (timers/queues) → build payload → FCM delivery
  → App foreground: in-app banner + badge
  → App background/killed: system tray → tap → deep link → screen
```

### 3.3 Deep Link Map
| Type | Route | Screen |
|------|-------|--------|
| checkinNudge | `/children/{id}/checkin` | CheckinScreen |
| cyclePrediction | `/children/{id}/cycle` | CycleHistoryScreen |
| calendarWeeklyDigest | `/children/{id}/reminders` | ReminderList |
| practiceWeeklyNudge | `/children/{id}/practice` | PracticeScreen |
| microLearning | `/library/{articleId}` | ArticleDetail |
| newArticleContent | `/library?category={cat}` | LibraryScreen |
| packageExpiry | `/settings/package` | PackageScreen |

### 3.4 Android Channels
| Channel | Priority |
|---------|----------|
| sscare_checkin | DEFAULT |
| sscare_calendar | DEFAULT |
| sscare_education | LOW |
| sscare_revenue | LOW |
| sscare_onboarding | DEFAULT |

---

## 4. Feature ↔ Notification Interaction

```
CHECK-IN ◄──── checkinNudge (tiers 1-7)
    │ body data feeds ──►
    ▼
CYCLE ENGINE ────► cyclePrediction notification

PRACTICE ◄──── practiceWeeklyNudge (Sunday)

LIBRARY ◄──── microLearning / coachingTip (daily)
        ◄──── newArticleContent (on admin publish)

REMINDERS ◄──── calendarWeeklyDigest (Saturday)
          ◄──── calendarDayReminder (6am)

ADMIN CMS ────► newArticleContent, adminBroadcast

MONETIZATION ────► packageExpiry / offerExpiry
```

---

## 5. UX Patterns (App Inspirations)

### 5.1 Duolingo — Streak & Habit
| Pattern | Adaptation |
|---------|-----------|
| Daily streak | "Bạn đã cập nhật liên tiếp 5 ngày! 🔥" |
| Streak freeze | Miss 1 day → gentle reminder, no punishment |
| Weekly ring | "4/7 ngày đã cập nhật" per child |
| Celebration | Subtle confetti on save |

### 5.2 TikTok — Micro-Learning
| Pattern | Adaptation |
|---------|-----------|
| Swipeable cards | 3-5 micro-lesson cards per session |
| Session limit | Max 5 cards. "Hẹn gặp lại ngày mai! 👋" |
| Skip/read | Swipe left = skip, right = read |

### 5.3 Instagram — Visual Journal
| Pattern | Adaptation |
|---------|-----------|
| Avatar ring | Green (today) / grey (pending) / amber (3+ days) |
| Story-like flow | Full-screen sequential: Emotion → Body → Symptoms → Notes |
| Emoji picker | Large animated emoji, tap to toggle |
| Calendar dots | Monthly view with colored dots |

### 5.4 Banking — Trust & Transparency
| Pattern | Adaptation |
|---------|-----------|
| Biometric lock | Optional fingerprint/face |
| Last login | "Đăng nhập gần nhất: 09/04/2026" |
| Data export | Download all data as PDF |
| PIN for destructive | Confirm before delete profile/account |

---

## 6. Notification Orchestration

| Rule | Detail |
|------|--------|
| Daily cap | Max 3/user/day |
| Priority | checkin > calendar > practice > education > revenue |
| Cooldown | Skip nudge if user active today |
| Smart timing | Default 7am/7pm, learn from active hours |
| Onboarding ramp | Week 1: 1/day max → Week 4+: normal |

---

## 7. Offline-First

| Feature | Offline | Sync |
|---------|---------|------|
| Check-in | Hive write, queue | POST on reconnect, last-write-wins |
| Measurements | Hive write, queue | Sync on restore |
| Reminders | Cached list | Server = truth |
| Library | Cached after read | Refresh on open |
| Reports | Last snapshot | Pull-to-refresh |

Sync queue: FIFO, max 5 retries, 409 → fetch server version.

---

## 8. Admin Portal (Blazor Server)

### Structure
```
AdminPortal/
├── Pages/
│   ├── Articles/ (List, Editor, Preview)
│   ├── Practice/ (TemplateList, TemplateEditor)
│   ├── Notifications/ (Broadcaster, History)
│   ├── Dashboard.razor
│   └── Users.razor
├── Components/
│   ├── MarkdownEditor.razor
│   ├── ImageUploader.razor
│   └── StatsCard.razor
└── Services/
    ├── AdminArticleService.cs
    ├── BlobStorageService.cs
    └── NotificationBroadcastService.cs
```

### Article Editor
- Left panel: Markdown/WYSIWYG input + toolbar
- Right panel: mobile-style live preview
- Image: drag-drop → Blob Storage → URL in body
- Metadata: Category, Tags, Age Group, Read Time
- Save as Draft → Publish (triggers notification) → Archive

### Session Model
- Blazor Server = SignalR circuit (server-side state)
- ~250KB RAM/circuit, fine for < 50 concurrent admins
- Auto-reconnect on blip, 3min timeout
- Same Entra ID auth, admin role claim required

---

## 9. Navigation (GoRouter)

```
/                           → /children (home)
├── /auth (/login, /register, /otp)
├── /onboarding (/welcome, /create-child)
├── /children
│   └── /{childId}
│       ├── /dashboard
│       ├── /checkin
│       ├── /measurements
│       ├── /cycle
│       ├── /practice
│       ├── /reminders
│       └── /reports (/growth, /cycle, /body)
├── /library
│   └── /{articleId}
├── /notifications
└── /settings (/profile, /package)
```

Guards: `AuthGuard` (not authenticated → login, no child → onboarding). No role guards — single role (parent).

---

## 10. Engagement Loops

**Loop 1 — Daily Habit (Duolingo):**
Parent journals → streak ↑ → reward → missed → nudge → journal again

**Loop 2 — Knowledge → Action (TikTok):**
Micro-learning → parent reads → practice item → mark complete → progress

**Loop 3 — Admin → Engagement:**
Admin publishes → notification → parent reads → rating/bookmark

### Anti-Patterns
| Avoid | Rule |
|-------|------|
| Spam | 3/day cap, cooldown |
| Guilt | Always positive framing |
| Overload day 1 | Onboarding drip |
| Pay-to-track | Basic check-in always free |

---

## 11. Key Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Scope | Parent-only | MVP simplicity |
| Architecture | MVVM + Repository + Riverpod | Testable, reactive |
| Admin CMS | Blazor Server, same App Service | Zero extra infra |
| Content | Markdown + flutter_markdown | Easy write, clean render |
| Session | Stateless JWT (mobile), SignalR circuit (admin) | Appropriate per client |
| No child auth | Child = profile | Simpler, no consent |
| Notifications | Server-side orchestration | Caps, A/B, analytics |
| UX | Duolingo streaks + TikTok cards + Instagram stories + Banking trust | Best-of-breed for parent engagement |
