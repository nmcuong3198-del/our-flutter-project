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

## 8. Admin CMS & Content Pipeline

### 8.1 End-to-End Content Flow

```
Admin (Web Browser)              API Server                  Database              Flutter App
───────────────────              ──────────                  ────────              ───────────
│                                     │                          │                      │
│  Open article editor                │                          │                      │
│  ─────────────────►                 │                          │                      │
│                                     │                          │                      │
│  Write title, body, upload images   │                          │                      │
│  ─── POST /admin/articles ────────► │                          │                      │
│                                     │  INSERT status=DRAFT ──► │                      │
│  ◄── 201 { id, status: draft } ─── │                          │                      │
│                                     │                          │                      │
│  Click "Preview"                    │                          │                      │
│  ─── GET /admin/articles/{id} ───►  │                          │                      │
│  ◄── article with rendered body ─── │                          │                      │
│  Show in mobile-width iframe        │                          │                      │
│                                     │                          │                      │
│  Click "Publish"                    │                          │                      │
│  ─── PUT /admin/articles/{id}/publish ►                        │                      │
│                                     │  UPDATE status=PUBLISHED │                      │
│                                     │  ──── Queue: notify ───► │                      │
│                                     │                          │                      │
│                                     │  ─── FCM push ──────────────────────────────► │
│                                     │                          │    "Bài viết mới!"   │
│                                     │                          │                      │
│                                     │               GET /articles ◄────────────────── │
│                                     │  ◄── SELECT WHERE status=published             │
│                                     │  ─── article list ─────────────────────────► │
│                                     │                          │    Shows in Library   │
```

### 8.2 Database Schema (Articles)

```
Articles
├── Id (PK, UUID)
├── Title (nvarchar 200)
├── Slug (nvarchar 200, unique, auto-generated)
├── Body (nvarchar max, Markdown/HTML)
├── Excerpt (nvarchar 500, auto or manual)
├── Category (nvarchar 50)
├── Tags (JSON array)
├── AgeGroup (nvarchar 20, nullable)
├── ImageUrl (nvarchar 500, nullable)
├── ReadMinutes (int)
├── Status (Draft | Published | Archived)
├── PublishedAt (datetime, nullable — supports scheduled publish)
├── AuthorAdminId (FK → Users)
├── CreatedAt (datetime)
└── UpdatedAt (datetime)

ArticleReadProgress
├── Id (PK)
├── UserId (FK → Users)
├── ArticleId (FK → Articles)
├── IsRead (bool)
├── TimeSpentSeconds (int)
└── ReadAt (datetime)
```

### 8.3 Admin Web Portal

```
Admin Portal (Web)
├── Article List        — Table: title, status, date, category. Filter by status
├── Article Editor      — Split view: editor (left) + mobile preview (right)
│   ├── Toolbar         — Bold, italic, heading, image, link, quote, list
│   ├── Image Upload    — Drag-drop → Azure Blob → URL inserted in body
│   ├── Metadata Panel  — Category, tags, age group, read time
│   └── Actions         — Save Draft | Preview | Publish | Schedule | Archive
├── Practice Templates  — CRUD by category × age × gender × month
├── Notification Push   — Compose, segment, schedule
└── Dashboard           — DAU, check-in rate, article reads, tier distribution
```

### 8.4 Preview Mode

Admin sees exactly what parents see before publishing:

```
┌──────────────────────────────────────────────────────────────┐
│  Article Editor                                     [Publish]│
├────────────────────────┬─────────────────────────────────────┤
│                        │  ┌─────────────┐                    │
│  # Title here          │  │  📱 375px   │  ← Mobile preview │
│                        │  │             │    (real render)   │
│  Body in Markdown...   │  │  Title      │                    │
│                        │  │  Tag  3min  │                    │
│  **Bold section**      │  │             │                    │
│  • Bullet point        │  │  Body text  │                    │
│  • Another point       │  │  rendered   │                    │
│                        │  │             │                    │
│  [Upload Image]        │  │  [Image]    │                    │
│                        │  │             │                    │
│  Category: [Dropdown]  │  │  ⭐⭐⭐⭐☆  │                    │
│  Tags: [Multi-select]  │  └─────────────┘                    │
│  Read time: [3] min    │                                     │
└────────────────────────┴─────────────────────────────────────┘
```

Preview renders the same Markdown → HTML transformation that `flutter_markdown` uses,
displayed in a 375px-wide iframe. What admin sees = what parent sees.

### 8.5 Blazor Server — Scalability Analysis

Blazor Server uses **SignalR websockets** to maintain a persistent circuit per admin tab.

**How it scales:**

| Metric | Blazor Server | Impact |
|--------|--------------|--------|
| RAM per circuit | ~250KB baseline, up to 1-2MB with editor state | 100 concurrent admins ≈ 200MB RAM |
| Connection limit | B1 App Service ≈ 300-500 concurrent websockets | Fine for < 100 admins |
| Latency | Every keystroke round-trips to server | Noticeable on slow networks (> 200ms RTT) |
| Offline | No — requires constant connection | Admin editing on train/plane = bad UX |
| Deploy complexity | Zero — same App Service as API | Simplest option |
| CPU per circuit | Minimal for CRUD, spikes during Markdown render | Not a concern |

**Scaling limits:**

| Admin Count | Blazor Server | Status |
|-------------|--------------|--------|
| 1-10 | Perfect | ✅ MVP |
| 10-50 | Fine on B1 | ✅ Growth |
| 50-200 | Need S1/P1 App Service | ⚠️ Consider upgrade |
| 200+ | Hitting websocket limits | ❌ Switch to SPA |

**Verdict for SSCare:**
- MVP: 1-5 admins → Blazor Server is ideal (zero extra infra, same C# backend)
- If admin team grows past ~50 → migrate to SPA

### 8.6 Alternative: SPA Admin (If/When Blazor Doesn't Scale)

If we outgrow Blazor Server, swap to a **client-side SPA** calling the same REST API:

| Option | Pros | Cons |
|--------|------|------|
| **Blazor WASM** | Same C# code, just recompile | 5MB+ initial download, slower startup |
| **React SPA** | Fast, huge ecosystem, rich text editors (TipTap, Lexical) | Different language (JS/TS), separate build |
| **Next.js** | SSR + SPA hybrid, great DX | JS/TS, more complex deploy |

**Migration cost:** Low — the `/admin/*` REST API endpoints don't change. Only the frontend rendering moves from server to client. All business logic stays in the API.

**Recommended path:**
```
MVP (now)           → Blazor Server (zero infra cost)
Growth (50+ admins) → Blazor WASM (same code, just recompile)
Scale (200+ admins) → React SPA (best editor experience)
```

### 8.7 Content Delivery to Flutter App

```
Flutter App
    │
    │  GET /articles?category=X&status=published
    │  Authorization: Bearer {jwt}
    │  ──────────────────────────────►
    │                                   API validates JWT (role=parent)
    │                                   SELECT FROM Articles
    │                                     WHERE Status='Published'
    │                                     AND (Category=X OR X is null)
    │                                     ORDER BY PublishedAt DESC
    │  ◄──────────────────────────────
    │  [{id, title, excerpt, imageUrl, category, tags, readMinutes}]
    │
    │  Cache article list in Hive (offline access)
    │
    │  User taps article
    │  GET /articles/{id}
    │  ──────────────────────────────►
    │  ◄──────────────────────────────
    │  {title, body (markdown), ...}
    │
    │  Render body via flutter_markdown
    │  Images loaded via Image.network() + cached_network_image
    │  Cache full article in Hive after first read
    │
    │  User finishes reading
    │  PUT /articles/{id}/read
    │  { timeSpentSeconds: 45 }
    │  ──────────────────────────────►
    │                                   INSERT ArticleReadProgress
```

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
| Admin CMS (MVP) | Blazor Server, same App Service | Zero extra infra, 1-5 admins |
| Admin CMS (Scale) | Blazor WASM → React SPA | Same API, swap frontend only |
| Content format | Markdown stored, flutter_markdown rendered | Easy write, clean render |
| Content pipeline | Admin web → API → DB → Flutter app | Standard CMS pattern, preview before publish |
| Session | Stateless JWT (mobile), SignalR circuit (admin) | Appropriate per client type |
| No child auth | Child = profile | Simpler, no consent |
| Notifications | Server-side orchestration | Caps, A/B, analytics |
| UX | Duolingo streaks + TikTok cards + Instagram stories + Banking trust | Best-of-breed for parent engagement |
