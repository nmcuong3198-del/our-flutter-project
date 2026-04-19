# SSCare — System Architecture

> **Scope v2:** Parent-only app. No child user accounts. Parent journals about their children.
> Admin portal for article/content management.

## 1. System Overview

```
┌──────────────────────────────────────────────────────────────────┐
│                        CLIENT LAYER                              │
│  ┌─────────────────────┐       ┌─────────────────────┐          │
│  │   Flutter App        │       │   Admin Web Portal   │          │
│  │   (Parent)           │       │   (Content Mgmt)     │          │
│  │   Android / iOS      │       │   Blazor Server      │          │
│  └────────┬────────────┘       └────────┬────────────┘          │
└───────────┼──────────────────────────────┼───────────────────────┘
            │           HTTPS/REST         │
            ▼                              ▼
┌──────────────────────────────────────────────────────────────────┐
│                      API GATEWAY LAYER                           │
│              Azure App Service (REST API)                         │
│              ASP.NET Core 8                                       │
│              /api/v1 (mobile)  +  /admin (CMS)                   │
└──────────────────────┬───────────────────────────────────────────┘
                       │
       ┌───────────────┼───────────────────┐
       ▼               ▼                   ▼
┌────────────┐  ┌─────────────┐  ┌──────────────────┐
│ Azure SQL  │  │ Azure Blob  │  │ Azure Functions  │
│ Database   │  │ Storage     │  │ (Background Jobs)│
│            │  │ (Images,    │  │ - Notifications  │
│ Users      │  │  Avatars,   │  │ - Cycle Predict. │
│ Children   │  │  Article    │  │ - Reminders      │
│ Checkins   │  │  Assets)    │  │ - Content Publish│
│ Content    │  │             │  │                  │
│ Packages   │  └─────────────┘  └──────────────────┘
└────────────┘
       ▲
       │
┌──────┴───────────────────────────────────────────────────────────┐
│                    IDENTITY & AUTH LAYER                          │
│              Microsoft Entra ID B2C                               │
│              - Email/Phone sign-up                                │
│              - OTP verification                                   │
│              - Google Sign-In                                     │
│              - Role claims (parent | admin)                       │
│              - 30-day refresh tokens                              │
└──────────────────────────────────────────────────────────────────┘
```

---

## 2. Technology Stack

| Layer | Technology | Justification |
|-------|-----------|---------------|
| **Mobile** | Flutter 3.x (Dart) | Single codebase for Android + iOS, sound null safety |
| **State Mgmt** | Riverpod | Compile-safe, testable, no BuildContext dependency |
| **Navigation** | GoRouter | Declarative routing, deep links |
| **Local Storage** | Hive / SharedPreferences | Offline check-in drafts, cached data |
| **HTTP Client** | Dio | Interceptors for auth tokens, retry logic |
| **Auth** | Microsoft Entra ID B2C | OAuth 2.0 / OIDC, social logins, custom policies |
| **Backend API** | ASP.NET Core 8 (C#) on Azure App Service | Strong typing, EF Core, Azure-native |
| **Admin Portal** | Blazor Server | Same backend stack, Blob upload, WYSIWYG editor |
| **Database** | Azure SQL Database (Basic tier) | Relational data, $5/mo fits budget |
| **File Storage** | Azure Blob Storage | Article images, avatars, content assets |
| **Background** | Azure Functions (Consumption) | Pay-per-execution, event-driven triggers |
| **Push Notif.** | Firebase Cloud Messaging (FCM) + APNs | Free, cross-platform push |
| **CI/CD** | GitHub Actions (Android) → Azure DevOps (iOS later) | Free tier for Android builds |

---

## 3. Flutter Project Structure

```
sscare/
├── android/
├── ios/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_strings.dart       # Vietnamese UI strings
│   │   │   └── api_endpoints.dart
│   │   ├── theme/
│   │   │   └── app_theme.dart
│   │   ├── network/
│   │   │   ├── api_client.dart
│   │   │   └── api_exceptions.dart
│   │   ├── storage/
│   │   │   └── local_storage.dart
│   │   └── utils/
│   │       ├── date_utils.dart
│   │       └── validators.dart
│   │
│   ├── features/
│   │   ├── auth/
│   │   │   ├── models/
│   │   │   ├── repositories/
│   │   │   ├── viewmodels/
│   │   │   └── views/
│   │   │
│   │   ├── children/                  # Child profile management
│   │   │   ├── models/
│   │   │   ├── repositories/
│   │   │   ├── viewmodels/
│   │   │   └── views/
│   │   │
│   │   ├── checkin/                   # Parent journals child's daily status
│   │   │   ├── models/
│   │   │   ├── repositories/
│   │   │   ├── viewmodels/
│   │   │   └── views/
│   │   │
│   │   ├── measurements/             # Height, weight, BMI
│   │   │   ├── models/
│   │   │   ├── repositories/
│   │   │   ├── viewmodels/
│   │   │   └── views/
│   │   │
│   │   ├── cycle/                     # Period/puberty tracking
│   │   │   ├── models/
│   │   │   ├── repositories/
│   │   │   ├── viewmodels/
│   │   │   └── views/
│   │   │
│   │   ├── practice/                  # Monthly practice actions
│   │   │   ├── models/
│   │   │   ├── repositories/
│   │   │   ├── viewmodels/
│   │   │   └── views/
│   │   │
│   │   ├── library/                   # Articles / knowledge base
│   │   │   ├── models/
│   │   │   ├── repositories/
│   │   │   ├── viewmodels/
│   │   │   └── views/
│   │   │
│   │   ├── reports/                   # Growth, cycle, body reports
│   │   │   ├── models/
│   │   │   ├── repositories/
│   │   │   ├── viewmodels/
│   │   │   └── views/
│   │   │
│   │   ├── reminders/
│   │   │   ├── models/
│   │   │   ├── repositories/
│   │   │   ├── viewmodels/
│   │   │   └── views/
│   │   │
│   │   ├── notifications/
│   │   │   ├── models/
│   │   │   ├── repositories/
│   │   │   ├── viewmodels/
│   │   │   └── views/
│   │   │
│   │   ├── settings/
│   │   │   ├── models/
│   │   │   ├── repositories/
│   │   │   ├── viewmodels/
│   │   │   └── views/
│   │   │
│   │   └── onboarding/
│   │       ├── viewmodels/
│   │       └── views/
│   │
│   ├── routing/
│   │   ├── app_router.dart
│   │   └── route_guards.dart
│   │
│   └── shared/
│       ├── widgets/
│       ├── extensions/
│       └── mixins/
│
├── test/
├── pubspec.yaml
└── iOS_TODO.txt
```

---

## 4. Data Model (Azure SQL)

```
┌─────────────────┐                        ┌─────────────────┐
│   Users          │                        │   Packages      │
├─────────────────┤                        ├─────────────────┤
│ Id (PK)         │                        │ Id (PK)         │
│ EntraId         │                        │ Name            │
│ Role            │  parent | admin        │ MaxChildren     │
│ SubRole         │  Bố|Mẹ|Người giám hộ  │ PriceVND        │
│ Email           │                        │ Features (JSON) │
│ Phone           │                        └────────┬────────┘
│ DisplayName     │                                 │
│ AvatarUrl       │                                 │
│ DateOfBirth     │                                 │
│ PackageId (FK)  │◄────────────────────────────────┘
│ AccountStatus   │  Active|Paused|Inactive
│ EditCount (JSON)│  tracks one-time editable fields
│ Locale          │
│ CreatedAt       │
└────────┬────────┘
         │ 1:N
         ▼
┌─────────────────────┐
│ ChildProfiles       │
├─────────────────────┤            ┌──────────────────────┐
│ Id (PK)             │            │ SharedParents        │
│ ParentId (FK)       │            ├──────────────────────┤
│ Nickname            │            │ Id (PK)              │
│ DateOfBirth         │            │ ChildProfileId (FK)  │
│ Gender              │ Male|F     │ SharedParentId (FK)  │
│ AvatarUrl           │            │ Status               │ Pending|Accepted
│ CreatedAt           │            │ CreatedAt            │
└──────┬──────────────┘            └──────────────────────┘
       │ 1:N
       ▼
┌────────────────────┐    ┌──────────────────────┐
│ DailyCheckins      │    │ CycleRecords         │
├────────────────────┤    ├──────────────────────┤
│ Id (PK)            │    │ Id (PK)              │
│ ChildProfileId(FK) │    │ ChildProfileId (FK)  │
│ ParentId (FK)      │    │ StartDate            │
│ Date               │    │ EndDate              │
│ Emotions (JSON)    │    │ FlowLevel            │
│ BodyStatus (JSON)  │    │ PainLevel            │
│ PhysicalSymptoms   │    │ Notes                │
│  (JSON)            │    │ CycleLength          │
│ PainLevel          │    └──────────────────────┘
│ Notes              │
│ CreatedAt          │    BodyStatus (gender-aware JSON):
└────────────────────┘      Female: {"menstruation":"in_period|discharge|not_in_period"}
                            Male:   {"puberty":"nocturnal_emission|tension|none"}

┌────────────────────┐    ┌──────────────────────┐
│ BodyMeasurements   │    │ PracticeItems        │
├────────────────────┤    ├──────────────────────┤
│ Id (PK)            │    │ Id (PK)              │
│ ChildProfileId(FK) │    │ ParentId (FK)        │
│ Month (YYYY-MM)    │    │ ChildProfileId (FK)  │
│ Height (cm)        │    │ MonthYear            │
│ Weight (kg)        │    │ Category             │ Quan sát|Giao tiếp|Hỗ trợ
│ BMI (computed)     │    │ Title                │
│ CreatedAt          │    │ Executor             │ Ông|Bà|Bố|Mẹ
│ UpdatedAt          │    │ PlannedWeek          │
└────────────────────┘    │ IsCompleted          │
                          │ CompletedAt          │
                          │ Notes                │
┌──────────────────────┐  └──────────────────────┘
│ Reminders            │
├──────────────────────┤  ┌──────────────────────┐
│ Id (PK)              │  │ Notifications        │
│ ParentId (FK)        │  ├──────────────────────┤
│ ChildProfileId (FK)  │  │ Id (PK)              │
│ Date                 │  │ UserId (FK)          │
│ Time                 │  │ Type                 │
│ Label                │  │ Title                │
│ IsActive             │  │ Body                 │
│ CreatedAt            │  │ DeepLink             │
└──────────────────────┘  │ IsRead               │
  Max 10 per child        │ CreatedAt            │
                          └──────────────────────┘

┌──────────────────────┐  ┌──────────────────────┐
│ Articles             │  │ ArticleBookmarks     │
├──────────────────────┤  ├──────────────────────┤
│ Id (PK)              │  │ Id (PK)              │
│ Title                │  │ UserId (FK)          │
│ Slug                 │  │ ArticleId (FK)       │
│ Body (HTML/Markdown) │  │ CreatedAt            │
│ Excerpt              │  └──────────────────────┘
│ Category             │
│ AgeGroup             │  ┌──────────────────────┐
│ Tags (JSON)          │  │ ArticleRatings       │
│ ImageUrl             │  ├──────────────────────┤
│ ReadMinutes          │  │ Id (PK)              │
│ Status               │  │ UserId (FK)          │
│ PublishedAt          │  │ ArticleId (FK)       │
│ AuthorAdminId (FK)   │  │ Stars (1-5)          │
│ CreatedAt            │  │ CreatedAt            │
│ UpdatedAt            │  └──────────────────────┘
└──────────────────────┘
  Status: Draft|Published|Archived

┌──────────────────────┐  ┌──────────────────────┐
│ ArticleReadProgress  │  │ PracticeTemplates    │
├──────────────────────┤  ├──────────────────────┤
│ Id (PK)              │  │ Id (PK)              │
│ UserId (FK)          │  │ MonthOffset          │
│ ArticleId (FK)       │  │ Category             │
│ IsRead               │  │ AgeGroupMin          │
│ ReadAt               │  │ AgeGroupMax          │
└──────────────────────┘  │ Gender               │
                          │ Title                │
┌──────────────────────┐  │ CreatedByAdminId(FK) │
│ NotifEscalationState │  │ CreatedAt            │
├──────────────────────┤  └──────────────────────┘
│ Id (PK)              │
│ ParentId (FK)        │
│ ChildProfileId (FK)  │
│ Type                 │
│ LastCheckinDate      │
│ EscalationTier       │
│ LastNotifiedAt       │
│ UpdatedAt            │
└──────────────────────┘
```

### Key Constraints

| Rule | Implementation |
|------|---------------|
| Free tier → max 1 child profile | Check `Packages.MaxChildren` on insert |
| Max 4 child profiles per parent | Hard limit regardless of package |
| Child age range | DOB must yield age 10-18 at creation |
| Reminders → max 10 per child | Count check before insert |
| Unique username | `DisplayName` unique across parents, max 25 chars |
| One-time editable fields | `EditCount` JSON tracks edits (max 1 each) |
| Daily check-in lock | If shared parent: first to save claims the day |
| Article visibility | Only `Status = Published` shown to parents |
| Practice auto-fill | Admin templates generate items monthly per child age/gender |

---

## 5. REST API Design

**Base URL:** `https://sscare-api.azurewebsites.net/api/v1`

### Auth
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/auth/register` | Register (email/phone + sub-role) |
| POST | `/auth/verify-otp` | Verify OTP code |
| POST | `/auth/login` | Login → returns JWT |
| POST | `/auth/refresh` | Refresh access token |

### Child Profiles
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/children` | List parent's child profiles |
| POST | `/children` | Create child profile |
| PUT | `/children/{id}` | Update child profile |
| DELETE | `/children/{id}` | Remove child profile |
| POST | `/children/{id}/share` | Invite another parent (by email/phone) |
| POST | `/children/{id}/share/accept` | Accept share invitation |

### Daily Check-in (parent journals about child)
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/children/{id}/checkins?date=` | Get check-in for date |
| POST | `/children/{id}/checkins` | Create/update today's check-in |
| GET | `/children/{id}/checkins/range?from=&to=` | Get check-ins in range |

### Body Measurements
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/children/{id}/measurements` | Get all monthly measurements |
| POST | `/children/{id}/measurements` | Add measurement for a month |
| PUT | `/children/{id}/measurements/{mid}` | Edit measurement |

### Cycle Tracking
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/children/{id}/cycles` | Get cycle history |
| POST | `/children/{id}/cycles` | Log cycle start/end |
| GET | `/children/{id}/cycles/prediction` | Next cycle prediction |
| GET | `/children/{id}/cycles/assessment` | Cycle stability assessment |

### Reminders
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/children/{id}/reminders` | List reminders (max 10) |
| POST | `/children/{id}/reminders` | Create reminder |
| PUT | `/reminders/{id}` | Update reminder |
| DELETE | `/reminders/{id}` | Delete reminder |

### Practice
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/children/{id}/practice?month=YYYY-MM` | Get practice items by category |
| PUT | `/practice/{id}/complete` | Mark complete |
| PUT | `/practice/{id}` | Update executor, week, notes |

### Reports
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/children/{id}/reports/growth` | Growth chart + WHO comparison |
| GET | `/children/{id}/reports/cycle?months=12` | 12-month cycle table |
| GET | `/children/{id}/reports/body?days=30` | Body condition summary |

### Library
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/articles?category=&ageGroup=&tag=` | List published articles |
| GET | `/articles/{id}` | Article detail |
| POST | `/articles/{id}/bookmark` | Save/unsave |
| GET | `/articles/bookmarks` | Saved articles |
| POST | `/articles/{id}/rate` | Rate (1-5 stars) |
| GET | `/articles/progress?category=` | Read progress (x/y) |
| PUT | `/articles/{id}/read` | Mark as read |

### Settings & Notifications
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/users/me` | Get profile |
| PUT | `/users/me` | Update profile |
| GET | `/notifications` | List notifications |
| PUT | `/notifications/{id}/read` | Mark as read |
| GET | `/notifications/config` | Notification preferences |
| PUT | `/notifications/config` | Update preferences |
| POST | `/notifications/register-device` | Register FCM token |

### Admin — Content Management (admin role required)
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/admin/articles` | List all articles (all statuses) |
| POST | `/admin/articles` | Create article (draft) |
| PUT | `/admin/articles/{id}` | Edit article |
| PUT | `/admin/articles/{id}/publish` | Publish → triggers push notification |
| PUT | `/admin/articles/{id}/archive` | Archive → hidden |
| POST | `/admin/articles/{id}/image` | Upload image → Blob Storage |
| GET | `/admin/practice-templates` | List practice templates |
| POST | `/admin/practice-templates` | Create template |
| PUT | `/admin/practice-templates/{id}` | Edit template |
| DELETE | `/admin/practice-templates/{id}` | Delete template |
| POST | `/admin/notifications/broadcast` | Push to user segment |
| GET | `/admin/stats` | DAU, check-in rate, article reads |

---

## 6. Content Loading & Session Architecture

### 6.1 Parent Mobile App — Stateless REST + JWT

```
Flutter App                          API                              DB / Blob
─────────                          ───                              ─────────
GET /articles?category=X    →    [Authorize] middleware     →    SELECT FROM Articles
Authorization: Bearer {jwt}       validates JWT, extracts          WHERE Status='Published'
                                  userId, role=parent

                             ←    200 OK [{id, title,       ←    returns rows
                                  excerpt, imageUrl, ...}]

GET /articles/42            →    [Authorize]                →    SELECT WHERE Id=42
                             ←    {title, body (markdown),
                                   imageUrl: "https://sscare.blob..."}
```

- **No server-side sessions.** Every request carries JWT bearer token
- **Dio interceptor** attaches `Authorization: Bearer {token}` automatically
- **Token lifecycle:** access token 1hr, refresh token 30 days, stored in EncryptedSharedPreferences
- **Article body:** Markdown stored in Azure SQL, rendered by `flutter_markdown`
- **Images:** stored in Azure Blob Storage, referenced by URL in article body
- **Caching:** Repository layer caches article list + body in Hive after first read

### 6.2 Admin Portal — Blazor Server (SignalR Circuit)

- Blazor Server maintains a **SignalR websocket circuit** per admin browser tab
- Editor state (draft content, unsaved changes) lives server-side in memory
- Circuit auto-reconnects on network blip (3min timeout before state loss)
- ~250KB RAM per circuit — fine for admin team < 50 concurrent users
- Same Entra ID auth — admin role claim required
- Hosted on same App Service as API (zero extra infra)

### 6.3 Image Upload Flow (Admin → Blob → Parent App)

```
Admin drags image into editor
  → POST /admin/articles/{id}/image (multipart/form-data)
  → API uploads to Azure Blob Storage
  → Returns { "url": "https://sscare.blob.core.windows.net/articles/abc.jpg" }
  → URL inserted into Markdown as ![alt](url)
  → Parent app renders via Image.network() with disk caching
```

### 6.4 Offline Content

| Data | Offline Behavior |
|------|-----------------|
| Article list (titles, excerpts) | Cached in Hive — viewable offline |
| Article body | Cached after first read |
| Images | Cached by `cached_network_image` (memory + disk) |
| Uncached article | "Cần kết nối mạng" message |

---

## 7. Admin CMS Architecture

### 7.1 Admin Web Portal

```
┌──────────────────────────────────────────────────────────────┐
│                    ADMIN WEB PORTAL                           │
│                    Blazor Server                              │
│                                                               │
│  ┌────────────────┐  ┌────────────────┐  ┌────────────────┐  │
│  │ Article Editor │  │ Practice Mgmt  │  │ Notification   │  │
│  │ • WYSIWYG/MD  │  │ • Templates    │  │ Broadcaster    │  │
│  │ • Image upload │  │   by age/gender│  │ • Segment users│  │
│  │ • Live preview│  │   /month       │  │ • Schedule     │  │
│  │ • Draft/Pub/  │  │ • Bulk import  │  │ • Copy editor  │  │
│  │   Archive     │  │                │  │                │  │
│  └────────────────┘  └────────────────┘  └────────────────┘  │
│                                                               │
│  ┌────────────────┐  ┌────────────────┐                      │
│  │ User Dashboard │  │ Analytics      │                      │
│  │ • User count   │  │ • DAU/MAU      │                      │
│  │ • Package tiers│  │ • Check-in %   │                      │
│  │ • Search users │  │ • Article reads│                      │
│  └────────────────┘  └────────────────┘                      │
└──────────────────────────────────────────────────────────────┘
```

### 7.2 Article Lifecycle

```
Admin creates article → [DRAFT]
  ↓ writes body (Markdown/HTML), uploads images, sets category/tags/age
  ↓ previews rendering
  ↓ clicks "Publish"
[PUBLISHED] → visible in parent app Library tab
  └── triggers ArticlePublishNotify → FCM push to parents
  ↓ clicks "Archive"
[ARCHIVED] → hidden from Library, data retained
```

### 7.3 Practice Template System

```
Admin creates PracticeTemplate:
  { monthOffset: 1, category: "Quan sát", ageGroupMin: 10, ageGroupMax: 12,
    gender: "female", title: "Quan sát biểu hiện cảm xúc của con khi tan học" }

Monthly Azure Function (PracticeAutoFill) — 1st of each month:
  → For each ChildProfile where age matches + gender matches:
    → Create PracticeItem records (3 per category) if not exists
    → Parent sees pre-filled items in app
```

---

## 8. Authentication & Authorization

### Token Strategy
- **Access token:** 1 hour expiry
- **Refresh token:** 30 days
- **Storage:** Flutter Secure Storage (EncryptedSharedPreferences on Android)

### Access Control

| Resource | Parent | Admin |
|----------|--------|-------|
| Child profiles | CRUD (own) | Read (analytics) |
| Check-ins | CRUD (own children) | Read (analytics) |
| Measurements | CRUD (own children) | — |
| Cycle records | CRUD (own children) | — |
| Practice items | Read/Update (own) | Manage templates |
| Articles | Read/Bookmark/Rate | Full CRUD + Publish/Archive |
| Reminders | CRUD (max 10/child) | — |
| Notifications config | Read/Write | Broadcast to segments |
| User management | Own profile | View all, analytics |

---

## 9. Privacy & Security

- **Parent owns all data** — no child user accounts, no consent system
- **Parent-to-parent sharing:** both parents have full read/write (with daily check-in lock)
- **All API traffic:** TLS 1.3
- **Auth tokens:** Flutter Secure Storage
- **Database:** Azure SQL TDE (Transparent Data Encryption)
- **Admin access:** separate role claim, admin endpoints reject parent tokens

---

## 10. Azure Infrastructure ($150/mo Budget)

| Service | SKU | Est. Cost/mo | Purpose |
|---------|-----|-------------|---------|
| App Service | B1 (Linux) | ~$13 | REST API + Blazor admin portal |
| Azure SQL | Basic (2GB) | ~$5 | Relational data |
| Blob Storage | Hot tier | ~$1 | Article images, avatars |
| Azure Functions | Consumption | ~$0 (free tier) | Background jobs |
| Entra ID B2C | Free tier (50K auth/mo) | $0 | Authentication |
| **Total** | | **~$19/mo** | |

---

## 11. Background Jobs (Azure Functions)

| Function | Trigger | Purpose |
|----------|---------|---------|
| `CyclePrediction` | Timer (daily 2am) | Predict next period for child profiles with data |
| `SendReminders` | Timer (every 15 min) | Check reminder schedules, push to parent |
| `CheckinEscalation` | Timer (daily 8am) | Tiered nudge: 1d→3d→7d→10d→14d→30d→60d |
| `MicroLearningPush` | Timer (daily) | Daily micro-learning notification |
| `WeeklyReminderDigest` | Timer (Saturday) | Summarize next week's reminders |
| `PracticeWeeklyNudge` | Timer (Sunday) | Remind of incomplete practice items |
| `PracticeAutoFill` | Timer (1st of month) | Generate practice items from admin templates |
| `ArticlePublishNotify` | Queue (on publish) | Notify parents of new articles |
| `ArticleSchedulePublish` | Timer (hourly) | Auto-publish scheduled articles |
| `SubscriptionLifecycle` | Timer (daily) | Package expiry/renewal nudges |
| `OnboardingDrip` | Timer (daily) | Onboarding sequence for new users |

---

## 12. Key Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| **Scope** | Parent-only (no child users) | MVP focus — parent journals about children |
| **Architecture** | MVVM + Repository | Testable, clean separation, Riverpod fit |
| **Admin CMS** | Blazor Server on same App Service | Zero extra infra, same auth |
| **Content format** | Markdown stored, flutter_markdown rendered | Easy for admin, clean in app |
| **Session model** | Stateless JWT (mobile), SignalR circuit (admin) | Mobile = REST, admin = server-rendered |
| **No child auth** | Child = profile, not user | Simpler auth, no consent system |
| **No consent system** | Removed | Parent owns all data |
| **Practice templates** | Admin-managed, auto-filled monthly | Scalable content distribution |
| **Android first** | Defer iOS | No Mac needed until Android complete |
# SSCare — System Architecture

## 1. System Overview

```
┌──────────────────────────────────────────────────────────────────┐
│                        CLIENT LAYER                              │
│  ┌─────────────────────┐       ┌─────────────────────┐          │
│  │   Flutter App        │       │   Flutter App        │          │
│  │   (Parent Role)      │       │   (Child Role)       │          │
│  │   Android / iOS      │       │   Android / iOS      │          │
│  └────────┬────────────┘       └────────┬────────────┘          │
└───────────┼──────────────────────────────┼───────────────────────┘
            │           HTTPS/REST         │
            ▼                              ▼
┌──────────────────────────────────────────────────────────────────┐
│                      API GATEWAY LAYER                           │
│              Azure API Management (optional)                     │
│              + Azure App Service (REST API)                      │
└──────────────────────┬───────────────────────────────────────────┘
                       │
       ┌───────────────┼───────────────────┐
       ▼               ▼                   ▼
┌────────────┐  ┌─────────────┐  ┌──────────────────┐
│ Azure SQL  │  │ Azure Blob  │  │ Azure Functions  │
│ Database   │  │ Storage     │  │ (Background Jobs)│
│            │  │ (Images,    │  │ - Notifications  │
│ Users      │  │  Avatars,   │  │ - Cycle Predict. │
│ Cycles     │  │  Articles)  │  │ - Reminders      │
│ Emotions   │  │             │  │ - Badge Awards   │
│ Content    │  └─────────────┘  └──────────────────┘
│ Consents   │
│ Packages   │
└────────────┘
       ▲
       │
┌──────┴───────────────────────────────────────────────────────────┐
│                    IDENTITY & AUTH LAYER                          │
│              Microsoft Entra ID B2C                               │
│              - Email/Phone sign-up                                │
│              - OTP verification                                   │
│              - Apple Sign-In / Google Sign-In                     │
│              - Role claims (parent | child)                       │
│              - 30-day refresh tokens                              │
└──────────────────────────────────────────────────────────────────┘
```

---

## 2. Technology Stack

| Layer | Technology | Justification |
|-------|-----------|---------------|
| **Mobile** | Flutter 3.x (Dart) | Single codebase for Android + iOS, sound null safety |
| **State Mgmt** | Riverpod | Compile-safe, testable, no BuildContext dependency |
| **Navigation** | GoRouter | Declarative routing, deep links, role-based guards |
| **Local Storage** | Hive / SharedPreferences | Offline emotion drafts, cached cycle data |
| **HTTP Client** | Dio | Interceptors for auth tokens, retry logic |
| **Auth** | Microsoft Entra ID B2C | OAuth 2.0 / OIDC, social logins, custom policies |
| **Backend API** | ASP.NET Core 8 (C#) on Azure App Service | Strong typing, EF Core, Azure-native |
| **Database** | Azure SQL Database (Basic tier) | Relational data, $5/mo fits budget |
| **File Storage** | Azure Blob Storage | Article images, avatars, content assets |
| **Background** | Azure Functions (Consumption) | Pay-per-execution, event-driven triggers |
| **Push Notif.** | Firebase Cloud Messaging (FCM) + APNs | Free, cross-platform push |
| **CI/CD** | GitHub Actions (Android) → Azure DevOps (iOS later) | Free tier for Android builds |

---

## 3. Flutter Project Structure

```
sscare/
├── android/
├── ios/
├── lib/
│   ├── main.dart                      # App entry, ProviderScope
│   ├── app.dart                       # MaterialApp.router config
│   │
│   ├── core/                          # Shared infrastructure
│   │   ├── constants/
│   │   │   ├── app_colors.dart        # #6C63FF, #FF6B9D, #4CAF50
│   │   │   ├── app_strings.dart       # Vietnamese UI strings
│   │   │   └── api_endpoints.dart
│   │   ├── theme/
│   │   │   └── app_theme.dart         # ThemeData, text styles
│   │   ├── network/
│   │   │   ├── api_client.dart        # Dio instance + interceptors
│   │   │   └── api_exceptions.dart
│   │   ├── storage/
│   │   │   └── local_storage.dart     # Hive/SharedPrefs wrapper
│   │   └── utils/
│   │       ├── date_utils.dart
│   │       └── validators.dart
│   │
│   ├── auth/                          # Authentication module
│   │   ├── data/
│   │   │   ├── auth_repository.dart
│   │   │   └── models/
│   │   │       └── user_model.dart
│   │   ├── providers/
│   │   │   └── auth_provider.dart
│   │   └── presentation/
│   │       ├── login_screen.dart
│   │       ├── role_select_screen.dart
│   │       ├── register_screen.dart
│   │       ├── otp_screen.dart
│   │       └── widgets/
│   │
│   ├── parent/                        # Parent role features
│   │   ├── understand_child/          # Tab 1: Hiểu con
│   │   │   ├── data/
│   │   │   │   ├── child_dashboard_repository.dart
│   │   │   │   └── models/
│   │   │   │       ├── child_summary_model.dart
│   │   │   │       └── cycle_prediction_model.dart
│   │   │   ├── providers/
│   │   │   │   └── child_dashboard_provider.dart
│   │   │   └── presentation/
│   │   │       ├── understand_child_screen.dart
│   │   │       └── widgets/
│   │   │           ├── child_card.dart
│   │   │           └── parenting_tip_card.dart
│   │   │
│   │   ├── practice/                  # Tab 2: Thực hành
│   │   │   ├── data/
│   │   │   │   ├── practice_repository.dart
│   │   │   │   └── models/
│   │   │   │       └── practice_item_model.dart
│   │   │   ├── providers/
│   │   │   │   └── practice_provider.dart
│   │   │   └── presentation/
│   │   │       ├── practice_screen.dart
│   │   │       └── widgets/
│   │   │
│   │   └── library/                   # Tab 3: Thư viện (Parent)
│   │       ├── data/
│   │       └── presentation/
│   │
│   ├── child/                         # Child role features
│   │   ├── daily_checkin/             # Tab 1: Mình mỗi ngày
│   │   │   ├── data/
│   │   │   │   ├── checkin_repository.dart
│   │   │   │   └── models/
│   │   │   │       ├── emotion_entry_model.dart
│   │   │   │       └── body_tracking_model.dart
│   │   │   ├── providers/
│   │   │   │   └── checkin_provider.dart
│   │   │   └── presentation/
│   │   │       ├── daily_checkin_screen.dart
│   │   │       └── widgets/
│   │   │           ├── emotion_picker.dart
│   │   │           └── body_tracker.dart
│   │   │
│   │   ├── understand_self/           # Tab 2: Hiểu mình
│   │   │   ├── data/
│   │   │   │   └── models/
│   │   │   │       ├── cycle_history_model.dart
│   │   │   │       └── reminder_model.dart
│   │   │   ├── providers/
│   │   │   │   └── cycle_provider.dart
│   │   │   └── presentation/
│   │   │       ├── understand_self_screen.dart
│   │   │       └── widgets/
│   │   │           ├── cycle_calendar.dart
│   │   │           └── reminder_list.dart
│   │   │
│   │   └── library/                   # Tab 3: Thư viện (Child)
│   │       ├── data/
│   │       └── presentation/
│   │
│   ├── shared/                        # Shared across roles
│   │   ├── library/                   # Common library logic
│   │   │   ├── data/
│   │   │   │   ├── article_repository.dart
│   │   │   │   └── models/
│   │   │   │       └── article_model.dart
│   │   │   └── providers/
│   │   │       └── article_provider.dart
│   │   ├── settings/
│   │   │   ├── data/
│   │   │   │   └── settings_repository.dart
│   │   │   └── presentation/
│   │   │       ├── settings_screen.dart
│   │   │       ├── sharing_permissions_screen.dart
│   │   │       ├── notification_config_screen.dart
│   │   │       └── child_profiles_screen.dart
│   │   ├── consent/
│   │   │   └── presentation/
│   │   │       └── consent_screen.dart
│   │   └── notifications/
│   │       ├── data/
│   │       │   └── notification_service.dart
│   │       └── providers/
│   │           └── notification_provider.dart
│   │
│   └── routing/
│       ├── app_router.dart            # GoRouter config
│       └── route_guards.dart          # Auth + role guards
│
├── test/
│   ├── unit/
│   ├── widget/
│   └── integration/
├── pubspec.yaml
└── iOS_TODO.txt                       # Deferred iOS-specific tasks
```

---

## 4. Data Model (Azure SQL)

### Entity Relationship Diagram

```
┌─────────────────┐    ┌──────────────────┐       ┌─────────────────┐
│   Users          │    │  ParentChild     │       │   Packages      │
├─────────────────┤    ├──────────────────┤       ├─────────────────┤
│ Id (PK)         │──┐ │ Id (PK)          │       │ Id (PK)         │
│ EntraId         │  ├>│ ParentId (FK)    │       │ Name            │
│ Role            │  │ │ ChildId (FK)     │       │ MaxChildren     │
│ SubRole         │  │ │ InviteCode       │       │ PriceVND        │
│ Email           │  │ │ Status           │       │ Features (JSON) │
│ Phone           │  └>│ CreatedAt        │       └─────────────────┘
│ DisplayName     │    └──────────────────┘              │
│ AvatarUrl       │                                      │
│ Gender          │    (SubRole: Bố|Mẹ|Người giám hộ)   │
│ DateOfBirth     │    (AccountStatus: Active|Paused|     │
│ PackageId       │     Inactive)                        │
│ AccountStatus   │                                      │
│ Locale          │                                      │
│ EditCount (JSON)│  ← tracks one-time editable fields   │
│ CreatedAt       │◄─────────────────────────────────────┘
└────────┬────────┘
       │
       │ 1:N
       ▼
┌────────────────────┐    ┌──────────────────────┐    ┌──────────────────┐
│ DailyCheckins      │    │  CycleRecords        │    │ SharingConsents  │
├────────────────────┤    ├──────────────────────┤    ├──────────────────┤
│ Id (PK)            │    │ Id (PK)              │    │ Id (PK)          │
│ ChildId (FK)       │    │ ChildId (FK)         │    │ ChildId (FK)     │
│ AuthorId (FK)      │    │ StartDate            │    │ ParentId (FK)    │
│ AuthorRole         │    │ EndDate              │    │ ShareCycle       │
│ Date               │    │ FlowLevel            │    │ ShareEmotions    │
│ Emotions (JSON)    │    │ PainLevel            │    │ ShareHealthAlert │
│ BodyStatus (JSON)  │    │ Notes                │    │ ShareBodyData    │
│ PhysicalSymptoms   │    │ CycleLength          │    │ UpdatedAt        │
│  (JSON)            │    └──────────────────────┘    └──────────────────┘
│ PainLevel          │
│ Notes (encrypted)  │    AuthorRole: parent|child
│ CreatedAt          │    BodyStatus JSON examples:
└────────────────────┘      Female: {"menstruation":"in_period|discharge|not_in_period"}
                            Male:   {"puberty":"nocturnal_emission|tension|none"}
                            PhysicalSymptoms: ["healthy","tired","headache",
                              "stomachache","backache","nausea","dizzy",
                              "acne","irritable","other:custom_text"]

┌────────────────────┐    ┌──────────────────────┐
│ BodyMeasurements   │    │ ParentCheckinLocks   │
├────────────────────┤    ├──────────────────────┤
│ Id (PK)            │    │ Id (PK)              │
│ ChildId (FK)       │    │ ChildId (FK)         │
│ Month (YYYY-MM)    │    │ Date                 │
│ Height (cm)        │    │ LockedByParentId(FK) │
│ Weight (kg)        │    │ CreatedAt            │
│ BMI (computed)     │    └──────────────────────┘
│ CreatedAt          │
│ UpdatedAt          │    Enforces: only 1 parent can
└────────────────────┘    check-in per child per day
┌──────────────────────┐    ┌──────────────────────┐
│  Articles            │    │ PracticeItems        │
├──────────────────────┤    ├──────────────────────┤
│ Id (PK)              │    │ Id (PK)              │
│ Title                │    │ ParentId (FK)        │
│ Body                 │    │ ChildId (FK)         │
│ Category             │    │ MonthYear            │
│ AgeGroup             │    │ Category             │ ← Quan sát|Giao tiếp|Hỗ trợ
│ Tags (JSON)          │    │ Title                │
│ ReadMinutes          │    │ Executor             │ ← Ông|Bà|Bố|Mẹ
│ ImageUrl             │    │ PlannedWeek          │
│ CreatedAt            │    │ IsCompleted          │
└──────────────────────┘    │ CompletedAt          │
                            │ Notes                │
Tags: ["understand",        └──────────────────────┘
 "explain_data",
 "actionable",
 "observation"]

┌──────────────────────┐  ┌──────────────────────┐
│ Notifications        │  │ Reminders            │
├──────────────────────┤  ├──────────────────────┤
│ Id (PK)              │  │ Id (PK)              │
│ UserId (FK)          │  │ ChildId (FK)         │
│ Type                 │  │ OwnerId (FK)         │ ← parent or child
│ Title                │  │ OwnerRole            │
│ Body                 │  │ Type                 │
│ IsRead               │  │ Date                 │
│ CreatedAt            │  │ Time                 │
└──────────────────────┘  │ IsActive             │
                          │ Label                │
                          └──────────────────────┘
                          Max: 10/child (parent), 5/child (child)

┌──────────────────────┐  ┌──────────────────────┐
│ ArticleShares        │  │ ArticleBookmarks     │
├──────────────────────┤  ├──────────────────────┤
│ Id (PK)              │  │ Id (PK)              │
│ ArticleId (FK)       │  │ UserId (FK)          │
│ SharedByUserId (FK)  │  │ ArticleId (FK)       │
│ SharedToUserId (FK)  │  │ CreatedAt            │
│ CreatedAt            │  └──────────────────────┘
└──────────────────────┘
                          ┌──────────────────────┐
┌──────────────────────┐  │ ArticleReadProgress  │
│ ArticleRatings       │  ├──────────────────────┤
├──────────────────────┤  │ Id (PK)              │
│ Id (PK)              │  │ UserId (FK)          │
│ UserId (FK)          │  │ ArticleId (FK)       │
│ ArticleId (FK)       │  │ IsRead               │
│ Stars (1-5)          │  │ ReadAt               │
│ CreatedAt            │  └──────────────────────┘
└──────────────────────┘

┌──────────────────────┐  ┌──────────────────────┐
│ HelpRequests         │  │ NotifEscalationState │
├──────────────────────┤  ├──────────────────────┤
│ Id (PK)              │  │ Id (PK)              │
│ ChildId (FK)         │  │ UserId (FK)          │
│ ParentId (FK)        │  │ Type                 │ ← checkin_nudge etc.
│ Message              │  │ LastCheckinDate      │
│ IsResolved           │  │ EscalationTier       │ ← 1d|3d|7d|14d|30d|60d
│ CreatedAt            │  │ LastNotifiedAt       │
└──────────────────────┘  │ UpdatedAt            │
                          └──────────────────────┘
```

### Key Constraints

| Rule | Implementation |
|------|---------------|
| Free tier → max 1 child | Check `Packages.MaxChildren` on `ParentChild` insert |
| Emotions → multiple per day | Validate `Emotions` JSON array (emoji + optional custom text ≤ 20 chars) |
| Reminders → max 10/child (parent), 5/child (child) | Count check on `Reminders` by `OwnerRole` before insert |
| Private notes → encrypted at rest | `Notes` column uses Always Encrypted (Azure SQL) |
| Child consent controls sharing | `SharingConsents` owned by child, parent read-only |
| Parent check-in lock per day | `ParentCheckinLocks` — first parent to save claims the day |
| One-time editable fields | `Users.EditCount` JSON tracks edits for DisplayName, SubRole, DateOfBirth (max 1 each) |
| Child age range | `DateOfBirth` must yield age 10-18 at registration |
| Unique username | `DisplayName` unique per role, max 25 chars, no special chars |
| Account auto-inactive | `AccountStatus` → Inactive when no linked child ≤ 18 |

---

## 5. REST API Design

**Base URL:** `https://sscare-api.azurewebsites.net/api/v1`

### Auth
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/auth/register` | Register (email/phone + role) |
| POST | `/auth/verify-otp` | Verify OTP code |
| POST | `/auth/login` | Login → returns JWT |
| POST | `/auth/refresh` | Refresh access token |
| POST | `/auth/invite` | Parent generates child invite code/QR |
| POST | `/auth/join` | Child joins via invite code |

### Child — Daily Check-in
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/child/checkins?date=YYYY-MM-DD` | Get check-in for date |
| POST | `/child/checkins` | Create/update today's check-in (emotions, body status, physical symptoms) |
| GET | `/child/checkins/range?from=&to=` | Get check-ins in date range |

### Child — Body Measurements
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/child/measurements` | Get all monthly measurements |
| POST | `/child/measurements` | Add/update measurement for a month (height, weight → BMI auto-computed) |
| PUT | `/child/measurements/{id}` | Edit existing measurement |

### Child — Help Request
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/child/help-request` | Send urgent help request to linked parent(s) |

### Child — Cycle
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/child/cycles` | Get cycle history |
| POST | `/child/cycles` | Log cycle start/end |
| GET | `/child/cycles/prediction` | Get next cycle prediction |
| GET | `/child/cycles/assessment` | Get cycle stability assessment |

### Child — Reminders
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/child/reminders` | List child-owned reminders (max 5) |
| POST | `/child/reminders` | Create reminder |
| PUT | `/child/reminders/{id}` | Update reminder |
| DELETE | `/child/reminders/{id}` | Delete reminder |

### Parent — Daily Check-in (for child)
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/parent/children/{childId}/checkins` | Parent submits check-in for child (daily lock applies) |
| GET | `/parent/children/{childId}/checkins?date=` | Get parent-authored check-in for date |

### Parent — Dashboard & Reports
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/parent/children` | List linked children with summaries |
| GET | `/parent/children/{childId}/dashboard` | Get shared dashboard data (consent-filtered) |
| GET | `/parent/children/{childId}/report/growth` | Growth chart data with WHO comparison |
| GET | `/parent/children/{childId}/report/cycle?months=12` | 12-month cycle history table |
| GET | `/parent/children/{childId}/report/body?days=30` | Body condition summary (last 30 days) |
| GET | `/parent/tips` | Get parenting tips for current context |

### Parent — Reminders (per child)
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/parent/children/{childId}/reminders` | List parent-owned reminders for child (max 10) |
| POST | `/parent/children/{childId}/reminders` | Create reminder |
| PUT | `/parent/reminders/{id}` | Update reminder |
| DELETE | `/parent/reminders/{id}` | Delete reminder |

### Parent — Practice
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/parent/practice?month=YYYY-MM&childId=` | Get practice items by category (Quan sát/Giao tiếp/Hỗ trợ) |
| PUT | `/parent/practice/{id}/complete` | Mark practice item complete |
| PUT | `/parent/practice/{id}` | Update executor, planned week, notes |

### Shared — Library
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/articles?category=&ageGroup=&tag=` | List articles (filtered by category, age, tag) |
| GET | `/articles/{id}` | Get article detail |
| POST | `/articles/{id}/share` | Share article with linked user |
| GET | `/articles/shared` | Get articles shared with me |
| POST | `/articles/{id}/bookmark` | Save/unsave article |
| GET | `/articles/bookmarks` | List saved articles |
| POST | `/articles/{id}/rate` | Rate article (1-5 stars) |
| GET | `/articles/progress?category=` | Get read progress (x/y per category) |
| PUT | `/articles/{id}/read` | Mark article as read |

### Shared — Settings & Consent
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/users/me` | Get current user profile |
| PUT | `/users/me` | Update profile |
| GET | `/consent` | Get sharing consent settings |
| PUT | `/consent` | Update sharing consent (child only) |
| GET | `/notifications/config` | Get notification preferences |
| PUT | `/notifications/config` | Update notification preferences |

### Shared — Notifications
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/notifications` | List notifications |
| PUT | `/notifications/{id}/read` | Mark as read |
| POST | `/notifications/register-device` | Register FCM/APNs token |

---

## 6. Authentication & Authorization

### Flow

```
┌──────────┐     ┌──────────────┐     ┌────────────────┐
│  Flutter  │────>│  Entra ID    │────>│  Backend API   │
│  App      │     │  B2C         │     │                │
│           │<────│              │<────│  Validates JWT │
│  Stores   │     │ Issues JWT   │     │  Extracts:     │
│  tokens   │     │ + refresh    │     │  - userId      │
│  securely │     │ token        │     │  - role        │
└──────────┘     └──────────────┘     └────────────────┘
```

### Token Strategy
- **Access token:** 1 hour expiry
- **Refresh token:** 30 days (per mobile_dev_strategy — no aggressive auto-logout)
- **Storage:** Flutter Secure Storage (Keychain on iOS, EncryptedSharedPreferences on Android)

### Role-Based Access

| Resource | Parent | Child |
|----------|--------|-------|
| Child daily check-in data | Read (if consented) + Write (own check-in, daily-locked) | Read/Write (own) |
| Emotion entries | Read (if consented) | Read/Write (own) |
| Cycle records | Read (if consented) | Read/Write (own) |
| Body measurements | Read (if consented) + Write | Read/Write (own) |
| Growth reports (WHO) | Read (if consented) | — |
| Practice items | Read/Write | — |
| Parenting tips | Read | — |
| Articles | Read/Share/Rate/Bookmark | Read/Bookmark |
| Consent settings | Read | Read/Write |
| Child profiles | Create/Edit/Unlink | — |
| Notifications config | Read/Write | Read/Write |
| Reminders (per child) | Read/Write (max 10) | Read/Write (max 5) |
| Help requests | Read (receive) | Write (send) |

### Consent Enforcement (Critical)

Every parent API call that reads child data **MUST** check `SharingConsents`:

```
GET /parent/children/{childId}/dashboard
  → Query SharingConsents WHERE ChildId = childId AND ParentId = currentUser
  → Filter response fields based on ShareCycle, ShareEmotions, ShareHealthAlert
  → NEVER expose: Notes, raw emotion text, specific dates unless consented
```

---

## 7. Privacy Architecture

### Data Classification

| Category | Examples | Visibility |
|----------|----------|------------|
| **Public** | Display name, avatar, package tier | Both roles |
| **Shared (consent-gated)** | App usage, development stage, cycle status, health alerts | Parent IF child consents |
| **Private (never shared)** | Specific dates, emotion journal, personal notes, body data | Child only |

### Encryption

| Data | At Rest | In Transit |
|------|---------|------------|
| Personal notes | Azure SQL Always Encrypted | TLS 1.3 |
| Emotion text | Azure SQL Always Encrypted | TLS 1.3 |
| Auth tokens | Flutter Secure Storage | TLS 1.3 |
| Cycle dates | Standard SQL encryption | TLS 1.3 |
| Article content | Standard SQL encryption | TLS 1.3 |

---

## 8. Azure Infrastructure ($150/mo Budget)

| Service | SKU | Est. Cost/mo | Purpose |
|---------|-----|-------------|---------|
| App Service | B1 (Linux) | ~$13 | REST API hosting |
| Azure SQL | Basic (2GB) | ~$5 | Relational data |
| Blob Storage | Hot tier | ~$1 | Images, avatars |
| Azure Functions | Consumption | ~$0 (free tier) | Background jobs |
| Entra ID B2C | Free tier (50K auth/mo) | $0 | Authentication |
| **Total** | | **~$19/mo** | Leaves headroom for scaling |

### Scaling Path

| Phase | Trigger | Action |
|-------|---------|--------|
| **MVP** | < 500 users | B1 App Service + Basic SQL |
| **Growth** | 500-5K users | S1 App Service + S0 SQL |
| **Scale** | 5K+ users | P1v3 + S1 SQL + Redis Cache |

---

## 9. Background Jobs (Azure Functions)

| Function | Trigger | Purpose |
|----------|---------|---------|
| `CyclePrediction` | Timer (daily 2am) | Calculate next period predictions for all active children |
| `SendReminders` | Timer (every 15 min) | Check reminder schedules (parent + child), send push notifications |
| `CheckinEscalation` | Timer (daily 8am) | Tiered nudge engine: 1d→3d→7d→14d→30d→60d without check-in. Different message per tier. Also notifies parent at 3d+ tiers |
| `MicroLearningPush` | Timer (daily) | Send daily 3-min learning notification (different content for parent vs child) |
| `WeeklyReminderDigest` | Timer (Saturday) | Summarize next week's reminders for parent and child |
| `PracticeWeeklyNudge` | Timer (Sunday) | Remind parent of incomplete practice items for the week |
| `BadgeAward` | Queue (on practice complete) | Evaluate and award badges |
| `ArticleShareNotify` | Queue (on article share) | Notify recipient of shared article |
| `HelpRequestNotify` | Queue (on help request) | Immediate push to parent when child sends help request |
| `SubscriptionLifecycle` | Timer (daily) | Check expiring packages, send renewal/upgrade nudges |
| `ArticleNewContentNotify` | Queue (on article publish) | Notify users of new library content |

---

## 10. Development Phases

### Phase 1 — Foundation (Weeks 1-3)
- [ ] Flutter project scaffold with folder structure
- [ ] Core theme, colors, typography
- [ ] Entra ID B2C setup + login/register flow
- [ ] Role selection (Parent / Child)
- [ ] GoRouter with auth guards
- [ ] Azure SQL schema migration (EF Core)
- [ ] Basic API: auth, user profile

### Phase 2 — Child Features (Weeks 4-6)
- [ ] Daily check-in: emotion picker (multi-select + custom "other" option)
- [ ] Daily check-in: gender-aware body tracking (female: menstruation/discharge; male: nocturnal emission/tension)
- [ ] Daily check-in: physical symptoms picker (multi-select)
- [ ] Daily check-in: private notes
- [ ] Body measurements: monthly height/weight/BMI entry + edit
- [ ] Cycle history view (12-month table)
- [ ] Cycle prediction engine
- [ ] Reminder CRUD (max 5 for child)
- [ ] Help request: send urgent SOS to parent
- [ ] Consent screen (first-time)

### Phase 3 — Parent Features (Weeks 7-9)
- [ ] Child dashboard (consent-filtered)
- [ ] Parent check-in for child (emotion/body, daily lock logic)
- [ ] Link child via invite code / QR
- [ ] Multi-parent linking (shared child code, max 1 shared parent)
- [ ] Practice items (3 categories: Quan sát/Giao tiếp/Hỗ trợ, executor, planned week)
- [ ] Reminders per child (max 10, calendar with weekly/daily notifications)
- [ ] Reports: growth chart with WHO comparison, cycle history, body condition summary
- [ ] Parenting tips
- [ ] Sharing permissions view (read-only)

### Phase 4 — Library & Notifications (Weeks 10-11)
- [ ] Article listing + detail with tags (understand/explain_data/actionable/observation)
- [ ] Article categories (Nuôi dưỡng tinh thần/Phát triển thể chất/Bồi đắp kỹ năng/Sự kiện cảnh báo)
- [ ] Article read progress tracking (x/y per category)
- [ ] Article bookmark (save) + rating (1-5 stars)
- [ ] Article sharing between parent ↔ child
- [ ] FCM integration
- [ ] Notification escalation engine (1d→3d→7d→14d→30d→60d tiers)
- [ ] Weekly reminder digest (Saturday) + daily reminder notifications
- [ ] Practice weekly nudge (Sunday)
- [ ] Notification preferences
- [ ] Background functions (reminders, nudges, predictions, help requests)

### Phase 5 — Monetization & Polish (Week 12)
- [ ] Package tiers UI + subscription lifecycle notifications
- [ ] Google Play billing integration
- [ ] Settings screen (account with one-time editable fields, child profiles, permissions)
- [ ] Account status management (Active/Paused/Inactive)
- [ ] QR code generation for child login
- [ ] Badge system
- [ ] UI polish, accessibility

### Phase 6 — Launch Prep (Weeks 13-16)
- [ ] Privacy policy page (GitHub Pages)
- [ ] Screenshots + store listing assets
- [ ] Google Play 20-tester closed testing (14-day clock)
- [ ] iOS pivot (if ready): TestFlight, SafeArea, Info.plist
- [ ] App Store + Play Store submission
- [ ] Launch day coordination

---

## 11. Key Architectural Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| **State management** | Riverpod | No BuildContext needed, testable, compile-safe |
| **Backend language** | C# / ASP.NET Core | Azure-native, strong typing, EF Core ORM |
| **Database** | Azure SQL (not Cosmos) | Relational data model, cheaper at small scale, ACID compliance for consent logic |
| **Auth** | Entra ID B2C (not Firebase Auth) | Already within Azure credits, custom policies for role claims |
| **Push notifications** | FCM + APNs (not Azure Notification Hubs) | Free, simpler setup, Flutter packages mature |
| **No auto-logout** | 30-day refresh token | Per feedback_for_huong — aggressive logout kills retention for kids |
| **Android first** | Defer iOS | Per strategy — no Mac needed until Android complete |
| **Consent-first privacy** | Child owns consent record | Core product value — child controls what parent sees |
| **Encrypted notes** | Always Encrypted columns | Even DB admins can't read private journal entries |

---

## Next Step

Initialize the Flutter project:

```bash
flutter create --org com.sscare --project-name sscare .
```
