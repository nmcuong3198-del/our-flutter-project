# SSCare — Software Requirements Document (SRD)

> Version 2.0 — April 2026
> **Scope:** Parent-only app. No child user accounts. Admin CMS for content.

---

## 1. Introduction

### 1.1 Purpose
Software requirements for SSCare — a mobile app where parents track and journal their children's health, puberty, emotions, and growth. An admin portal enables content management.

### 1.2 Scope
- **Users:** Parents only (no child accounts)
- **Platform:** Flutter (Dart), Android first, iOS deferred
- **Backend:** ASP.NET Core 8 + Blazor Server admin
- **Database:** Azure SQL

### 1.3 Conventions
- **[MUST]** — Required for MVP | **[SHOULD]** — Can slip to v1.1 | **[COULD]** — Post-MVP

---

## 2. User Roles & Account

### FR-2.1 Roles
| Role | Sub-Role | Description |
|------|----------|-------------|
| Parent | Bố / Mẹ / Người giám hộ | Primary user, journals about children |
| Admin | — | Content management (web portal only) |

### FR-2.2 Parent Registration [MUST]
- Input: Sub-role, Email or Phone, Display Name (max 25 chars, unique)
- OTP verification via email/SMS
- 1 email/phone = 1 account

### FR-2.3 Child Profile Creation [MUST]
- Parent creates child profiles (min 1 to proceed)
- Input: Nickname (25 chars), DOB (age 10-18), Gender (Male/Female)
- Child is a data profile, NOT a user account
- Max 4 profiles (tier-limited: Tier 1→1, Tier 2→2, Tier 3→3-4)

### FR-2.4 Parent-to-Parent Sharing [SHOULD]
- Share child profile with 1 other parent via email/phone
- Daily check-in lock: first parent to save claims the day

### FR-2.5 Account Settings [MUST]
- One-time editable (with warning): Display Name, Sub-Role, DOB
- Always editable: Avatar, Email/Phone (if unset), Password
- Account status: Active / Paused / Inactive (auto when no child ≤ 18)

### FR-2.6 Authentication [MUST]
- Login via Email/Phone + password, OTP recovery
- Access token: 1hr, Refresh token: 30 days
- Stateless JWT — no server sessions for mobile app

---

## 3. Parent Journal Features

### 3.1 Daily Check-in [MUST]

#### FR-3.1.1 Emotion Check-in
- Multi-select: Vui/Bình thường/Chán mệt/Buồn/Cáu/Lo lắng/Uể oải/Khác
- "Khác": free text (20 chars) + icon picker

#### FR-3.1.2 Body Status (Gender-Aware)
- Female: Đang trong kỳ / Khí hư / Không trong kỳ / Dậy thì
- Male: Mộng tinh / Căng tức / Không có gì / Dậy thì

#### FR-3.1.3 Physical Symptoms
- Multi-select: Khỏe/Mệt/Đau đầu/Đau bụng/Đau lưng/Buồn nôn/Chóng mặt/Nổi mụn/Khó chịu/Khác

#### FR-3.1.4 Notes
- Free-text parent observations

#### FR-3.1.5 Save Behavior
- Partial save OK, "Lưu" → "Đã lưu" popup
- One record per child per date per parent
- Shared child: daily lock applies

### 3.2 Body Measurements [MUST]
- Monthly: Height (cm), Weight (kg), BMI auto-computed
- Edit existing month
- WHO comparison: Thấp hơn/Cao hơn/Trong ngưỡng (height/weight), Gầy/BT/Thừa (BMI)

### 3.3 Cycle Tracking [MUST]
- 12-month rolling table: Có / Không / Chưa có dữ liệu
- Assessment priority logic (last 3 months)
- Server-side prediction (rolling average)
- "Lần gần nhất: X ngày trước"

### 3.4 Reminders [MUST]
- Max 10 per child, Date + Label, toggle active/inactive
- Notifications: weekly digest (Saturday) + day-of (6am)

---

## 4. Practice ("Cùng con") [MUST]
- 3 categories: Quan sát / Giao tiếp / Hỗ trợ
- Auto-filled from admin templates (by child age/gender/month)
- Per action: Title (read-only), Status, Executor (Ông/Bà/Bố/Mẹ), Planned Week, Notes
- History preserved across months
- Paid gate after free trial for basic tier

---

## 5. Library [MUST]
- 4 categories + "Bài đọc đã lưu" (bookmarks)
- Article tags: Hiểu vấn đề / Giải thích dữ liệu / Hành động / Quan sát
- Read progress per category: "x/y bài đã đọc"
- Actions: Bookmark, Rate (1-5), Mark as read
- Content loaded via REST API + JWT, Markdown rendered by flutter_markdown
- Images from Azure Blob, cached locally

---

## 6. Reports [MUST]
- Growth report: chart + WHO overlay, filter 12/24/36mo/5yr
- Cycle report: 12-month table + assessment
- Body condition: last 30 days, count per symptom/status

---

## 7. Admin Content Management [MUST]

### FR-7.1 Article Management
- WYSIWYG / Markdown editor, image upload (Blob), live preview
- Lifecycle: Draft → Published → Archived
- Optional scheduled publish
- On publish: push notification to parents

### FR-7.2 Practice Templates
- Create by: category × age range × gender × month
- Auto-fill generates PracticeItems per child monthly

### FR-7.3 Notification Broadcasting
- Compose, segment (all / by tier / by child age), schedule

### FR-7.4 Analytics
- User count, DAU/MAU, check-in rate, article reads, tier distribution

---

## 8. Notification System [MUST]

All notifications target parents only.

### 8.1 Check-in Escalation (7 tiers)
| Tier | Days | Message |
|------|------|---------|
| 1 | 1 | "Đừng quên cập nhật thông tin của bé [tên] hôm nay nhé!" |
| 2 | 3 | "3 ngày rồi chưa cập nhật bé [tên]..." |
| 3 | 7 | "1 tuần rồi chưa cập nhật bé [tên]..." |
| 4 | 10 | "Đã lâu rồi chưa cập nhật bé [tên]..." |
| 5 | 14 | "Đã lâu rồi chưa cập nhật bé [tên]!" |
| 6 | 30 | "Cập nhật thường xuyên giúp theo dõi sức khoẻ bé [tên] tốt hơn!" |
| 7 | 60 | "SSCare lo lắng bé [tên] có ổn không?" |

### 8.2 Cycle Prediction Reminder
- "Kỳ kinh dự kiến của bé [tên] sắp đến" (female, ≥2 cycles)

### 8.3 Calendar Reminders
- Weekly (Saturday) + day-of (6am), grouped per child A-Z

### 8.4 Practice Reminders
- Sunday: incomplete items only

### 8.5 Education / Micro-learning
- Daily coaching tips, suggested questions, self-care tips

### 8.6 Library New Content
- On admin publish

### 8.7 Onboarding Drip (Weeks 1-4)
- Scheduled welcome sequence for new users

### 8.8 Revenue (Parent Only)
- Package expiry, offer expiry, milestone upgrade prompt
- Never show payment messaging in aggressive/pushy way

---

## 9. Monetization [SHOULD]
| Tier | Children | Features |
|------|----------|----------|
| Cơ bản (Free) | 1 | Basic check-in, limited reports |
| Nâng cao | 2 | Full reports, practice |
| Cao cấp | 3-4 | All features |

Paywall: "Bạn cần nâng cấp tài khoản..." — Google Play billing

---

## 10. Non-Functional Requirements
- API < 500ms (p95), cold start < 3s
- Offline: cache 7 days check-ins, sync on reconnect
- TLS 1.3, Flutter Secure Storage, OWASP Mobile Top 10
- Vietnamese only (MVP), dd/MM/yyyy
- Touch target ≥ 48dp, text scaling 200%, screen reader labels

---

## 11. WHO Reference Data (Seed)

### Boys (5-19) Median
| Age | Height | Weight | BMI |
|-----|--------|--------|-----|
| 10 | 138 | 32 | 16.4 |
| 11 | 144 | 37 | 16.9 |
| 12 | 151 | 41 | 17.5 |
| 13 | 157 | 46 | 18.2 |
| 14 | 163 | 49 | 19.0 |
| 15 | 169 | 55 | 19.8 |
| 16 | 173 | 60 | 20.5 |
| 17 | 175 | 64 | 21.1 |
| 18 | 176 | 67 | 21.7 |

### Girls (5-19) Median
| Age | Height | Weight | BMI |
|-----|--------|--------|-----|
| 10 | 138 | 32 | 16.6 |
| 11 | 145 | 36 | 17.2 |
| 12 | 154 | 41 | 18.0 |
| 13 | 156 | 45 | 18.8 |
| 14 | 160 | 50 | 19.6 |
| 15 | 161 | 53 | 20.2 |
| 16 | 162 | 55 | 20.7 |
| 17 | 163 | 56 | 21.0 |
| 18 | 163 | 57 | 21.3 |
