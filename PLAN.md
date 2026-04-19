# SSCare — Project Plan & Feature Breakdown

> Version 2.0 — April 2026
> Scope: Parent-only mobile app + Admin CMS
> Platform: Flutter/Dart (Android first) + ASP.NET Core + Blazor Server
> **Timeline: 4 weeks (1 month) — AI agent-accelerated development**

---

## Acceleration Strategy

| Factor | How Agent Helps |
|--------|----------------|
| **Scaffold generation** | Agent generates full MVVM folders, models, repositories, viewmodels, boilerplate in minutes |
| **API endpoints** | Agent writes EF Core entities, controllers, DTOs, validation from data model spec |
| **UI screens** | Agent builds Flutter screens from wireframe descriptions — emotion picker, body tracker, reports |
| **Tests** | Agent generates unit + widget tests alongside feature code |
| **Repetitive CRUD** | Children, reminders, practice, bookmarks — same pattern, agent stamps them out |
| **Admin portal** | Agent scaffolds Blazor pages, editor components, Blob upload service |
| **Azure Functions** | Agent writes timer/queue functions from spec (escalation, prediction, auto-fill) |
| **Parallel tracks** | You review + guide while agent builds the next feature simultaneously |

---

## Phase Overview (4-Week Sprint)

| Phase | Name | Duration | Focus |
|-------|------|----------|-------|
| **1** | Foundation + Core Journal | Days 1–7 | Scaffold, auth, DB, child profiles, daily check-in, measurements |
| **2** | Reports + Practice + Reminders | Days 8–14 | Reports, cycle prediction, practice, reminders, parent sharing |
| **3** | Admin CMS + Library + Notifications | Days 15–21 | Blazor admin, articles, FCM, escalation engine |
| **4** | Polish + Launch Prep | Days 22–28 | Monetization basics, UI polish, store submission |

---

## Phase 1 — Foundation + Core Journal (Days 1–7)

> Scaffold everything, get auth working, build the primary journal feature.
> Agent generates most boilerplate; you focus on Azure setup + review.

| ID | Feature | Type | Details |
|----|---------|------|---------|
| F-01 | Flutter project scaffold | Setup | MVVM structure, core folders, theme, colors |
| F-02 | App theme & typography | Setup | Vietnamese strings, app_colors, app_theme |
| F-03 | Dio API client + interceptors | Infra | Base URL, auth header injection, retry logic |
| F-04 | Hive local storage setup | Infra | Cache layer for offline support |
| F-05 | Flutter Secure Storage | Infra | Encrypted token storage |
| F-06 | GoRouter navigation | Infra | Route tree, auth guard |
| F-07 | Azure SQL schema + EF Core | Backend | All tables, migrations, seed data |
| F-08 | ASP.NET Core API scaffold | Backend | Project structure, middleware, DI |
| F-09 | Entra ID B2C setup | Backend | Tenant, user flows, custom policies |
| F-10 | Register (email/phone + OTP) | Auth | Sub-role: Bố/Mẹ/Người giám hộ |
| F-11 | Login (email/phone + password) | Auth | JWT access + refresh tokens |
| F-12 | Password recovery (OTP) | Auth | |
| F-13 | Token refresh flow | Auth | Dio interceptor auto-refresh |
| F-14 | Profile management | Account | View/edit profile, one-time editable fields |
| F-15 | Account status | Account | Active/Paused/Inactive |
| F-16 | Create child profile | Core | Nickname, DOB (10-18), gender. Min 1 to proceed |
| F-17 | Edit/delete child profile | Core | |
| F-18 | Child avatar | Core | Upload or pick default |
| F-19 | Home screen (child list) | UI | Cards per child, avatar with status ring |
| F-20 | Onboarding flow | UI | Welcome → create first child → home |

| F-21 | Emotion check-in | Check-in | Multi-select: 8 emotions + "Khác" |
| F-22 | Body status check-in | Check-in | Gender-aware: female vs male options |
| F-23 | Physical symptoms check-in | Check-in | Multi-select: 10 symptoms + "Khác" |
| F-24 | Notes | Check-in | Free text observations |
| F-25 | Partial save | Check-in | "Lưu" → "Đã lưu" popup |
| F-26 | View check-in history | Check-in | By date, by range |
| F-27 | Check-in flow (sequential) | UX | Full-screen: Emotion → Body → Symptoms → Notes |
| F-28 | Emoji picker | UX | Large emoji, tap to select |
| F-29 | Monthly height/weight | Measurement | Auto-compute BMI |
| F-30 | Edit existing month | Measurement | Select → auto-fill → edit → save |
| F-31 | WHO comparison | Measurement | Thấp hơn/Cao hơn/Trong ngưỡng |
| F-32 | WHO seed data | Backend | Reference tables ages 5-19 |
| F-33 | 12-month cycle history | Cycle | Có/Không/Chưa có dữ liệu per month |
| F-34 | Cycle assessment logic | Cycle | Priority rules based on last 3 months |
| F-35 | "Lần gần nhất" display | Cycle | X ngày trước |
| F-36 | Offline check-in queue | Infra | Hive write, sync on reconnect |

### Day 1–2: Scaffold + Backend
- [ ] Agent generates: Flutter project, MVVM folders, core/, all feature/ stubs
- [ ] Agent generates: ASP.NET Core project, EF Core entities, DbContext, all migrations
- [ ] Agent generates: API controllers + DTOs for auth, children, checkins, measurements, cycles
- [ ] You: Azure SQL deploy, Entra ID B2C tenant setup, App Service deploy
- [ ] You: Review + test generated code

### Day 3–4: Auth + Child Profiles
- [ ] Agent builds: login/register/OTP screens, auth repository, Dio interceptors
- [ ] Agent builds: child profile CRUD (list, form, card widget)
- [ ] Agent builds: GoRouter with auth guard, onboarding flow
- [ ] You: Test auth flow end-to-end, fix Entra ID config issues

### Day 5–7: Core Journal
- [ ] Agent builds: check-in screen (emotion picker, body tracker, symptom grid, notes)
- [ ] Agent builds: measurement screen + WHO comparison widget
- [ ] Agent builds: cycle history table + assessment display
- [ ] Agent builds: offline queue (Hive write → sync service)
- [ ] You: Review UX flow, test check-in save/load, verify offline sync

### Phase 1 Deliverable
- [ ] Full app running: auth → child profiles → daily check-in → measurements → cycle
- [ ] API deployed and serving all core endpoints
- [ ] Offline check-in works

---

---

## Phase 2 — Reports + Practice + Reminders (Days 8–14)

> Data insights, guided practice, reminders. Agent builds all screens from patterns established in Phase 1.

| ID | Feature | Type | Details |
|----|---------|------|---------|
| F-37 | Growth report + chart | Report | Height/weight plotted over time, WHO overlay |
| F-38 | Growth filter | Report | 12/24/36 months or 5 years |
| F-39 | Cycle report (12-month table) | Report | Same data as history + assessment summary |
| F-40 | Body condition report (30 days) | Report | Count of days per symptom/status |
| F-41 | Cycle prediction engine | Backend | Azure Function, daily, rolling average |
| F-42 | Cycle prediction notification | Backend | "Kỳ kinh dự kiến sắp đến" for female profiles with ≥2 cycles |
| F-43 | Child dashboard screen | UI | Summary card per child: last check-in, streak, cycle status, growth snapshot |
| F-44 | Check-in streak counter | UX | Duolingo-style: "5 ngày liên tiếp 🔥" |
| F-45 | Weekly progress ring | UX | "4/7 ngày đã cập nhật" per child |
| F-46 | Avatar status ring | UX | Green (today) / grey (not yet) / amber (3+ days) |
| F-47 | Celebration animation on save | UX | Subtle confetti |

| F-48 | Practice items (3 categories) | Practice | Quan sát / Giao tiếp / Hỗ trợ |
| F-49 | Mark practice complete | Practice | Status toggle |
| F-50 | Set executor + week + notes | Practice | Dropdown + text |
| F-51 | View previous months | Practice | History preserved |
| F-52 | Paid gate on practice | Practice | Basic tier lock |
| F-53 | Create reminder | Reminder | Max 10/child, date + label |
| F-54 | Edit/delete/toggle reminder | Reminder | CRUD |
| F-55 | Share child with parent | Sharing | ★ DEFER to v1.1 |
| F-56 | Daily check-in lock | Sharing | ★ DEFER to v1.1 |

### Day 8–10: Reports + Dashboard
- [ ] Agent builds: growth report screen + chart widget (fl_chart)
- [ ] Agent builds: cycle report screen + body condition report
- [ ] Agent builds: child dashboard (summary card, streak, avatar ring)
- [ ] Agent builds: CyclePrediction Azure Function
- [ ] You: Review chart rendering, verify WHO comparison logic

### Day 11–14: Practice + Reminders
- [ ] Agent builds: practice screen (3 tabs, action cards, complete/executor/notes)
- [ ] Agent builds: reminder list + form (CRUD, max 10)
- [ ] Agent builds: home screen polish (week ring, streak counter, status rings)
- [ ] You: Test full flow: check-in → appears in reports → dashboard updated

### Phase 2 Deliverable
- [ ] 3 report types with charts
- [ ] Cycle prediction running
- [ ] Practice + reminders functional
- [ ] Dashboard with streaks + progress rings

---

---

## Phase 3 — Admin CMS + Library + Notifications (Days 15–21)

> Admin content pipeline + parent library + push notifications. Biggest phase — agent handles bulk generation.

| ID | Feature | Type | Details |
|----|---------|------|---------|
| **Admin Portal** | | | |
| A-01 | Blazor Server project scaffold | Admin | Same App Service, Entra ID admin role |
| A-02 | Article WYSIWYG / Markdown editor | Admin | Rich text editing with toolbar |
| A-03 | Image upload (drag-drop → Blob) | Admin | Returns URL, inserted into body |
| A-04 | Live mobile-style preview | Admin | Side-by-side editor + preview |
| A-05 | Draft → Publish → Archive lifecycle | Admin | Status filter on article list |
| A-06 | Schedule future publish | Admin | Set PublishedAt, auto-publish via Function |
| A-07 | Article metadata | Admin | Category, tags, age group, read time, excerpt |
| A-08 | Practice template CRUD | Admin | Category × age × gender × month |
| A-09 | Practice auto-fill Function | Backend | 1st of month: templates → PracticeItems per child |
| A-10 | Notification broadcaster | Admin | Compose, segment, schedule |
| A-11 | Analytics dashboard | Admin | User count, DAU, check-in %, article reads |
| **Parent Library** | | | |
| F-60 | Article list by category | Library | 4 tabs: Tinh thần/Thể chất/Kỹ năng/Cảnh báo |
| F-61 | "Bài đọc đã lưu" tab | Library | 5th tab: bookmarked articles |
| F-62 | Article detail (Markdown rendered) | Library | flutter_markdown, images from Blob |
| F-63 | Article tags | Library | 4 types: Hiểu vấn đề/Giải thích/Hành động/Quan sát |
| F-64 | Bookmark article | Library | Save/unsave |
| F-65 | Rate article (1-5 stars) | Library | |
| F-66 | Read progress per category | Library | "x/y bài đã đọc" |
| F-67 | Mark article as read | Library | |
| F-68 | Micro-learning swipeable cards | Library | TikTok-style, max 5/session |
| F-69 | Offline article cache | Library | Hive cache after first read |

| F-70 | FCM integration | Infra | firebase_messaging, token registration |
| F-71 | Notification channels | Infra | 5 Android channels |
| F-72 | Notification center | UI | List + mark read |
| F-73 | Deep link routing | Infra | Notification → GoRouter → screen |
| F-74 | Notification preferences | UI | Per channel toggles |
| B-01 | Check-in escalation | Backend | 7 tiers: 1d→60d |
| B-02 | Reminder push | Backend | 15min interval check |
| B-03 | Weekly digest (Saturday) | Backend | All children combined |
| B-04 | Practice nudge (Sunday) | Backend | Incomplete items |
| B-05 | Article publish notification | Backend | Queue on publish |
| B-06 | Notification orchestrator | Backend | 3/day cap, priority, cooldown |
| B-07 | Micro-learning push | Backend | ★ DEFER to v1.1 |
| B-08 | Coaching tip push | Backend | ★ DEFER to v1.1 |
| B-09 | Onboarding drip | Backend | ★ DEFER to v1.1 |

### Day 15–17: Admin CMS
- [ ] Agent builds: Blazor Server project, admin layout, auth (admin role)
- [ ] Agent builds: ArticleEditor (Markdown + toolbar), ImageUploader (Blob), ArticleList
- [ ] Agent builds: PracticeTemplate CRUD pages
- [ ] Agent builds: PracticeAutoFill Azure Function
- [ ] You: Azure Blob Storage setup, test image upload flow

### Day 18–19: Parent Library
- [ ] Agent builds: LibraryScreen (4 category tabs + bookmarks tab)
- [ ] Agent builds: ArticleDetail (flutter_markdown), ArticleCard widget
- [ ] Agent builds: bookmark, rating, read progress features
- [ ] You: Seed 5-10 test articles via admin portal, verify rendering

### Day 20–21: Notifications
- [ ] Agent builds: FCM setup, notification_service, notification_handler, notification_router
- [ ] Agent builds: NotificationCenter screen, channel config
- [ ] Agent builds: Azure Functions (escalation, reminder push, weekly digest, practice nudge)
- [ ] Agent builds: Notification orchestrator (cap + priority logic)
- [ ] You: Test end-to-end: create reminder → wait → receive push → tap → lands on screen

### Phase 3 Deliverable
- [ ] Admin can create/publish/archive articles with images
- [ ] Practice templates auto-fill for children
- [ ] Library fully functional in parent app
- [ ] Push notifications working with escalation + deep links

---

---

## Phase 4 — Polish + Launch Prep (Days 22–28)

> Monetization basics, UI polish, store submission. Cut non-essentials.

| ID | Feature | Type | Details |
|----|---------|------|---------|
| F-77 | Package tiers UI | Monetize | Cơ bản (1 child) / Nâng cao (2) / Cao cấp (3-4) |
| F-78 | Google Play billing | Monetize | In-app purchase integration |
| F-79 | Subscription lifecycle notifications | Backend | Expiry warning, renewal nudge, offer expire |
| F-80 | Paywall enforcement | Monetize | Lock advanced features for basic tier |
| F-81 | Biometric lock (optional) | Polish | Fingerprint/face to open app |
| F-82 | Data export (PDF) | Polish | Download all child data |
| F-83 | Last login timestamp | Polish | Settings transparency |
| F-84 | PIN confirm for destructive actions | Polish | Delete child profile, delete account |
| F-85 | UI polish pass | Polish | Spacing, transitions, loading states |
| F-86 | Accessibility pass | Polish | 48dp touch targets, text scaling, screen reader labels |
| F-87 | A/B notification copy testing | Admin | Send variants to subsets |

| F-81 | Biometric lock | Polish | ★ DEFER to v1.1 |
| F-82 | Data export (PDF) | Polish | ★ DEFER to v1.1 |
| F-83 | A/B notification testing | Admin | ★ DEFER to v1.1 |
| F-84 | Admin analytics dashboard | Admin | ★ DEFER to v1.1 |
| L-01 | Privacy policy page | Legal | GitHub Pages |
| L-02 | Store listing copy | Store | Vietnamese |
| L-03 | Screenshots (5+ screens) | Store | Key flows |
| L-04 | Feature graphic | Store | 1024x500 |
| L-05 | Google Play closed testing | Store | 20 testers, 14-day requirement |
| L-06 | Bug fix sprint | QA | Tester feedback |
| L-07 | Security review | QA | OWASP check |
| L-08 | Play Store submission | Launch | Production release |

### Day 22–23: Monetization
- [ ] Agent builds: Package tier UI, paywall overlay, tier check middleware
- [ ] You: Google Play Console setup, billing config
- [ ] Agent builds: subscription lifecycle Azure Function

### Day 24–25: UI Polish
- [ ] Agent + You: UI polish pass (spacing, transitions, loading states, error states)
- [ ] Agent builds: settings screen (profile, notification prefs, package)
- [ ] Accessibility: touch targets, text scaling, screen reader labels

### Day 26: Store Prep
- [ ] Agent generates: privacy policy page
- [ ] You: screenshots, store listing copy, feature graphic
- [ ] You: upload to Google Play, start closed testing (14-day clock begins)

### Day 27–28: Bug Fix + QA
- [ ] Fix issues from testing
- [ ] Performance check: cold start < 3s, API < 500ms
- [ ] Security review
- [ ] Submit to Play Store

### Phase 4 Deliverable
- [ ] Monetization gated
- [ ] App polished and accessible
- [ ] Submitted to Play Store (or closed testing underway)

---

---

## Features Deferred to v1.1

Cut from MVP to hit 4-week timeline:

| ID | Feature | Reason |
|----|---------|--------|
| F-55 | Share child with another parent | Complex auth flow, low day-1 value |
| F-56 | Daily check-in lock (shared) | Depends on F-55 |
| F-68 | Micro-learning swipeable cards | Polish feature, articles work fine without it |
| F-81 | Biometric lock | Nice-to-have |
| F-82 | Data export (PDF) | Nice-to-have |
| F-83 | A/B notification testing | Optimization, not core |
| F-84 | Admin analytics dashboard | Can check DB directly for MVP |
| B-07 | Micro-learning daily push | Content pipeline not ready day 1 |
| B-08 | Coaching tip push | Content pipeline not ready day 1 |
| B-09 | Onboarding drip campaign | Can add after launch, needs content |

---

## Dependency Graph (Compressed)

```
Phase 1 (Days 1–7)      Phase 2 (Days 8–14)     Phase 3 (Days 15–21)    Phase 4 (Days 22–28)
┌──────────────────┐    ┌──────────────────┐    ┌──────────────────┐    ┌──────────────────┐
│ Scaffold + Auth  │───►│ Reports          │───►│ Admin CMS        │───►│ Monetization     │
│ Child Profiles   │    │ Practice         │    │ Library          │    │ Polish           │
│ Daily Check-in   │    │ Reminders        │    │ Notifications    │    │ Store Submission │
│ Measurements     │    │ Dashboard        │    │ FCM + Escalation │    │ Bug Fixes        │
│ Cycle Tracking   │    │ Streak / Rings   │    │                  │    │                  │
└──────────────────┘    └──────────────────┘    └──────────────────┘    └──────────────────┘
```

Each phase builds on the previous. No parallelization needed — agent speed replaces what would have been parallel developer tracks.

---

## Daily Rhythm

| Time | Activity |
|------|----------|
| Morning | You: review yesterday's agent output, test, fix config/deploy issues |
| Midday | You: describe next features to agent, agent generates code |
| Afternoon | Agent: builds screens, APIs, tests. You: review PRs, test flows |
| Evening | You: commit, push, plan tomorrow's batch |

---

## Summary

| Phase | Days | Features Built | Deferred |
|-------|------|---------------|----------|
| 1 – Foundation + Core Journal | 1–7 | 36 | 0 |
| 2 – Reports + Practice + Reminders | 8–14 | 20 | 2 (sharing) |
| 3 – Admin CMS + Library + Notifications | 15–21 | 32 | 3 (drip/tips) |
| 4 – Polish + Launch | 22–28 | 16 | 5 (polish) |
| **Total** | **28 days** | **104 shipped** | **10 deferred to v1.1** |

**Note:** 14-day Google Play closed testing requirement means submit by Day 14 at latest to have approval by Day 28. Alternative: submit Day 26, launch ~Day 40.
