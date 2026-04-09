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
┌─────────────┐       ┌──────────────────┐       ┌─────────────────┐
│   Users      │       │  ParentChild     │       │   Packages      │
├─────────────┤       ├──────────────────┤       ├─────────────────┤
│ Id (PK)     │──┐    │ Id (PK)          │       │ Id (PK)         │
│ EntraId     │  ├───>│ ParentId (FK)    │       │ Name            │
│ Role        │  │    │ ChildId (FK)     │       │ MaxChildren     │
│ Email       │  │    │ InviteCode       │       │ PriceVND        │
│ DisplayName │  └───>│ Status           │       │ Features (JSON) │
│ AvatarUrl   │       │ CreatedAt        │       └─────────────────┘
│ PackageId   │       └──────────────────┘              │
│ Locale      │                                         │
│ CreatedAt   │◄────────────────────────────────────────┘
└──────┬──────┘
       │
       │ 1:N
       ▼
┌────────────────────┐    ┌──────────────────────┐    ┌──────────────────┐
│ DailyCheckins      │    │  CycleRecords        │    │ SharingConsents  │
├────────────────────┤    ├──────────────────────┤    ├──────────────────┤
│ Id (PK)            │    │ Id (PK)              │    │ Id (PK)          │
│ ChildId (FK)       │    │ ChildId (FK)         │    │ ChildId (FK)     │
│ Date               │    │ StartDate            │    │ ParentId (FK)    │
│ Emotions (JSON)    │    │ EndDate              │    │ ShareCycle       │
│ MenstruationStatus │    │ FlowLevel            │    │ ShareEmotions    │
│ DischargeStatus    │    │ PainLevel            │    │ ShareHealthAlert │
│ PainLevel          │    │ Notes                │    │ UpdatedAt        │
│ Notes (encrypted)  │    │ CycleLength          │    └──────────────────┘
│ CreatedAt          │    └──────────────────────┘
└────────────────────┘
                          ┌──────────────────────┐    ┌──────────────────┐
                          │  Articles            │    │ PracticeItems    │
                          ├──────────────────────┤    ├──────────────────┤
                          │ Id (PK)              │    │ Id (PK)          │
                          │ Title                │    │ ParentId (FK)    │
                          │ Body                 │    │ ChildId (FK)     │
                          │ Category             │    │ MonthYear        │
                          │ AgeGroup             │    │ Theme            │
                          │ ReadMinutes          │    │ ActionType       │
                          │ ImageUrl             │    │ Title            │
                          │ CreatedAt            │    │ IsCompleted      │
                          └──────────────────────┘    │ CompletedAt      │
                                                      │ Notes            │
┌──────────────────────┐  ┌──────────────────────┐    └──────────────────┘
│ Notifications        │  │ Reminders            │
├──────────────────────┤  ├──────────────────────┤
│ Id (PK)              │  │ Id (PK)              │
│ UserId (FK)          │  │ ChildId (FK)         │
│ Type                 │  │ Type                 │
│ Title                │  │ Time                 │
│ Body                 │  │ IsActive             │
│ IsRead               │  │ Label                │
│ CreatedAt            │  └──────────────────────┘
└──────────────────────┘

┌──────────────────────┐
│ ArticleShares        │
├──────────────────────┤
│ Id (PK)              │
│ ArticleId (FK)       │
│ SharedByUserId (FK)  │
│ SharedToUserId (FK)  │
│ CreatedAt            │
└──────────────────────┘
```

### Key Constraints

| Rule | Implementation |
|------|---------------|
| Free tier → max 1 child | Check `Packages.MaxChildren` on `ParentChild` insert |
| Emotions → max 3 per day | Validate `Emotions` JSON array length ≤ 3 |
| Reminders → max 5 per child | Count check on `Reminders` before insert |
| Private notes → encrypted at rest | `Notes` column uses Always Encrypted (Azure SQL) |
| Child consent controls sharing | `SharingConsents` owned by child, parent read-only |

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
| POST | `/child/checkins` | Create/update today's check-in |
| GET | `/child/checkins/range?from=&to=` | Get check-ins in date range |

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
| GET | `/child/reminders` | List reminders (max 5) |
| POST | `/child/reminders` | Create reminder |
| PUT | `/child/reminders/{id}` | Update reminder |
| DELETE | `/child/reminders/{id}` | Delete reminder |

### Parent — Dashboard
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/parent/children` | List linked children with summaries |
| GET | `/parent/children/{childId}/dashboard` | Get shared dashboard data |
| GET | `/parent/tips` | Get parenting tips for current context |

### Parent — Practice
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/parent/practice?month=YYYY-MM` | Get practice items for month |
| PUT | `/parent/practice/{id}/complete` | Mark practice item complete |
| PUT | `/parent/practice/{id}/notes` | Add optional notes |

### Shared — Library
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/articles?category=&ageGroup=` | List articles (filtered) |
| GET | `/articles/{id}` | Get article detail |
| POST | `/articles/{id}/share` | Share article with linked user |
| GET | `/articles/shared` | Get articles shared with me |

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
| Child daily check-in data | Read (if consented) | Read/Write (own) |
| Emotion entries | Read (if consented) | Read/Write (own) |
| Cycle records | Read (if consented) | Read/Write (own) |
| Practice items | Read/Write | — |
| Parenting tips | Read | — |
| Articles | Read/Share | Read |
| Consent settings | Read | Read/Write |
| Child profiles | Create/Edit/Unlink | — |
| Notifications config | Read/Write | Read/Write |

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
| `SendReminders` | Timer (every 15 min) | Check reminder schedules, send push notifications |
| `EmotionCheckinNudge` | Timer (configurable) | Send emotion check-in reminder if not logged today |
| `MicroLearningPush` | Timer (daily) | Send daily 3-min learning notification |
| `BadgeAward` | Queue (on practice complete) | Evaluate and award badges |
| `ArticleShareNotify` | Queue (on article share) | Notify recipient of shared article |

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
- [ ] Daily check-in: emotion picker (max 3)
- [ ] Daily check-in: body tracking (menstruation, discharge, pain)
- [ ] Daily check-in: private notes
- [ ] Cycle history view (12-month table)
- [ ] Cycle prediction engine
- [ ] Reminder CRUD (max 5)
- [ ] Consent screen (first-time)

### Phase 3 — Parent Features (Weeks 7-9)
- [ ] Child dashboard (consent-filtered)
- [ ] Link child via invite code / QR
- [ ] Practice items (monthly themes, completion tracking)
- [ ] Parenting tips
- [ ] Sharing permissions view (read-only)

### Phase 4 — Library & Notifications (Weeks 10-11)
- [ ] Article listing + detail
- [ ] Article categories + age filtering
- [ ] Article sharing between parent ↔ child
- [ ] FCM integration
- [ ] Notification preferences
- [ ] Background functions (reminders, nudges, predictions)

### Phase 5 — Monetization & Polish (Week 12)
- [ ] Package tiers UI
- [ ] Google Play billing integration
- [ ] Settings screen (account, child profiles, permissions)
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
