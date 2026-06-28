# UI Design vs. Flutter Implementation — Comparison Report

**Date:** 2026-06-14
**Designs:** `1. UI/` (47 screen folders, latest = Update 27.05.2026), each containing `code.html` and/or `screen.png`
**Baseline compared against:** `our-flutter-project/lib/screens/` (16 Dart screens)

> Method: every design `code.html` was read in full; the 7 folders that ship only a `screen.png` (no markup) were inspected visually. Each design screen was mapped to the closest Flutter screen and classified.

---

## 1. Executive Summary

| Status | Count | Meaning |
|---|---|---|
| ✅ Implemented | 6 | Exists in Flutter, close to design |
| 🟡 Partial | 18 | Exists but missing sections / different layout |
| 🔴 Missing | 11 | Feature/flow has no Flutter equivalent |
| 🆕 New-in-design | 12 | Brand-new screens/states introduced by these updates |

**Total design screens reviewed: 47**

### The big themes
1. **A child legal-consent flow is brand new** (7.4–7.7): legal notice → hand phone to child → child reads terms → child confirms. Flutter has none of this. This is a compliance feature (children 7+ must consent themselves).
2. **Height-prediction feature is brand new** (4.8 input, 4.9 result) — parent heights in, predicted range out. No Flutter code exists.
3. **Article authoring is brand new** (5.1 write-permission variant, 5.10 create form, 5.11 success) — a full rich editor with sections, cover image, hashtags, moderation. No Flutter code exists.
4. **Library search is missing** (5.3) — there is no search screen or logic in Flutter at all.
5. **Polish gap across the app:** designs use full **modal dialogs** with icons/illustrations for success/confirm states; Flutter mostly uses `SnackBar`s. Designs also distinguish **logged-in / logged-out / has-permission** states that Flutter renders identically.
6. **Check-in was restructured** into a tabbed **Check-in / Đo lường (measurements)** screen with modal sub-pickers and a new **"Điều ảnh hưởng" (influencing factors)** category that Flutter doesn't have.

---

## 2. Screen-by-Screen Mapping

Legend: ✅ Implemented · 🟡 Partial · 🔴 Missing · 🆕 New-in-design

### Group 1 — Home / Landing / Child picker

| # | Design screen | Flutter target | Status |
|---|---|---|---|
| 1.1 | trang chu 1 (landing, logged-out) | `landing_screen.dart` | ✅ |
| 1.2 | pop-up 1 (login-required modal) | inline `_showLoginPrompt` | 🟡 |
| 1.3 | trang chu 2 (dashboard, logged-in) | `dashboard_screen.dart` | ✅ |
| 1.4 | pop-up 2 (create-profile-required modal) | SnackBar only | 🔴 |
| 2 | chon con (child picker) | `child_picker.dart` (shared) | 🟡 |

**Key gaps**
- **Child picker (2):** design is a **full-screen 2-column grid** with selection check-badge and a dashed **"+ Thêm hồ sơ"** card; Flutter is a **bottom-sheet vertical list** with no add button and no selected indicator.
- **1.4** wants a proper modal ("Tạo hồ sơ con" / "Để sau"); Flutter only shows a SnackBar.
- **1.2** modal copy/visuals (lock icon, "Yêu cầu đăng nhập", footer gradient) should be verified against `_showLoginPrompt`.

---

### Group 3 — Hiểu con (Check-in)

| # | Design screen | Flutter target | Status |
|---|---|---|---|
| 3.1 | check in (full, image only) | `checkin_tab.dart` | 🟡 |
| 3.1 | check in chung | `checkin_tab.dart` | 🟡 |
| 3.2 | check in cảm xúc (emotions modal) | `checkin_tab.dart` (emotions) | 🟡 |
| 3.2 | check in cơ thể (body modal) | `checkin_tab.dart` (body) | 🟡 |
| 3.2 | check in điều ảnh hưởng (influences modal) | — | 🔴 |
| 3.2 | sơ đồ / Đo lường (image only) | `measurements_tab.dart` | 🟡 |
| 3.3 | pop-up 3 (daily journal: meals + sleep) | — | 🆕 |

**Key gaps**
- **Tabbed shell:** design splits Hiểu con into **Check-in** and **Đo lường** tabs and uses a **date carousel**; Flutter uses one page + a date-picker dialog.
- **Modal sub-pickers:** emotions/body/influences are **3-tab modals** in design; Flutter stacks them on one page.
- **Điều ảnh hưởng (3.2)** is entirely missing — design tracks context (học tập, bạn bè, gia đình, mạng xã hội, thầy cô); Flutter's "Symptoms" is health-only.
- **Emotion set:** design has 12 emotions (adds Phấn khích, Áp lực, Cô đơn, Kiệt sức); Flutter has 8.
- **3.3 daily journal** (breakfast/lunch/dinner + sleep duration, with overwrite-confirm popup) has no Flutter equivalent.

---

### Group 4 — Cùng con (Practice) + Báo cáo (Reports)

| # | Design screen | Flutter target | Status |
|---|---|---|---|
| 4.1 | cùng con - hành động | `practice_tab.dart` | 🟡 |
| 4.2 | cùng con - ghi chú (note form) | `reminders_tab.dart` | 🔴 |
| 4.3 | báo cáo - tăng trưởng chiều cao | `reports_tab.dart` | 🟡 |
| 4.4 | báo cáo - tăng trưởng cân nặng | `reports_tab.dart` | 🟡 |
| 4.5 | báo cáo - chu kỳ (image only) | `cycle_tab.dart` | 🟡 |
| 4.6 | báo cáo - cơ thể (image only) | `reports_tab.dart` `_BodyConditionReport` | 🟡 |
| 4.7 | báo cáo - tất cả trạng thái | — | 🔴 |
| 4.8 | báo cáo - dự báo chiều cao (nhập) | — | 🆕 |
| 4.8 | báo cáo - WHO (reference tables) | `measurements_tab.dart` `_WhoRow` | 🟡 |
| 4.9 | báo cáo - dự báo chiều cao (kết quả, image only) | — | 🆕 |

**Key gaps**
- **Height prediction (4.8 + 4.9):** full new feature — inputs (current height, father, mother) → predicted range result with parent comparison + disclaimer. None in Flutter.
- **Reports layout:** design leads with **3 KPI metric cards** (height/weight/BMI with Δ) and a **"NHẬN XÉT" expert-assessment** box; Flutter is chart-first and shows a body-condition report instead.
- **4.7 "tất cả trạng thái":** unified dashboard of every emotional/physical/cycle state with per-state day counts. Flutter only aggregates symptoms.
- **4.2 ghi chú:** design is an inline note-creation **form** (title / date / content + Save); Flutter `reminders_tab` only has cards + an "Thêm ghi chú" button stub.
- **WHO (4.8):** design shows full **reference tables** (boys & girls, ages 5–19); Flutter only does a single child-vs-WHO comparison row.
- **Practice (4.1):** design = flat action list with per-item status dropdown + date + Add/Save buttons; Flutter = tabbed (Quan sát/Giao tiếp/Hỗ trợ) with checkboxes and week tags.

---

### Group 5 — Thư viện (Library)

| # | Design screen | Flutter target | Status |
|---|---|---|---|
| 5.1 | user login | `library_screen.dart` | 🟡 |
| 5.1 | user login có quyền viết bài | `library_screen.dart` | 🆕 |
| 5.2 | không user login | — (no logged-out variant) | 🔴 |
| 5.3 | button tìm kiếm (search results) | — | 🔴 |
| 5.4 | chi tiết bài viết | `article_detail_screen.dart` | 🟡 |
| 5.5 | popup đánh giá bài viết | rating `AlertDialog` | 🟡 |
| 5.6 | popup cảm ơn đánh giá | SnackBar | 🟡 |
| 5.7 | popup lưu thành công | — (no save feature) | 🔴 |
| 5.8 | popup chia sẻ (email recipient) | SnackBar | 🔴 |
| 5.9 | popup chia sẻ thành công | SnackBar | 🟡 |
| 5.10 | tạo bài viết (write form) | — | 🔴 |
| 5.11 | popup gửi bài thành công | — | 🔴 |

**Key gaps**
- **Article authoring (5.10 + 5.11 + 5.1 write-variant):** full editor — title (counter), cover upload, up to 10 dynamic content sections, summary, conclusion, category, hashtags, preview, moderation success. Plus an `edit_note` header button shown only to users with write permission. None in Flutter.
- **Search (5.3):** no search screen, input, or results list anywhere in Flutter.
- **Logged-out library (5.2):** design hides progress + saved-articles and changes the header; Flutter renders the same regardless of auth.
- **Save/bookmark (5.7):** no save action or success state in Flutter.
- **Article detail (5.4):** design adds **hero image**, **expert-author verification box**, **related articles**, and a 3-button (Rate/Save/Share) solid bar; Flutter has only Rate + Share.
- **Modals vs SnackBars:** rating (no feedback textarea / "Để sau"), share (no email field), and all success states should become proper modals.
- **Progress + category grid:** design's "Tiến trình tìm hiểu" % bar and 2×2 category cards aren't in the Flutter tabbed list.

---

### Group 6 — Đăng nhập / Đăng ký (Auth)

| # | Design screen | Flutter target | Status |
|---|---|---|---|
| 6.1 | đăng nhập | `LoginScreen` (auth_screens.dart) | 🟡 |
| 6.2 | đăng ký (role selection, step 1/3) | — (role is a dropdown) | 🆕 |
| 6.3 | đăng ký - tạo tk (create account) | `RegisterScreen` (auth_screens.dart) | 🟡 |

**Key gaps**
- **Stepped registration (6.2):** design is a **3-step flow** with progress bar + role chosen via large **radio cards** (Bố / Mẹ / Người giám hộ khác); Flutter collapses everything into one form with a role **dropdown**.
- **Confirm password + field hints (6.3):** design has a "Nhắc lại mật khẩu" field and helper text under every field ("Tối thiểu 8 ký tự…"); Flutter has neither.
- **Login styling (6.1):** design uses a gradient full-width button, centered layout, decorative blurred circles, and a prominent "TẠO TÀI KHOẢN" button; Flutter uses a plain `ElevatedButton` and an inline register link.

---

### Group 7 — Quản lý tài khoản (Account) + Group 8 — Thông báo

| # | Design screen | Flutter target | Status |
|---|---|---|---|
| 7.1 | thông tin tài khoản (image only) | `profile_screen.dart` | 🟡 |
| 7.2 | quản lý hồ sơ con | `profile_screen.dart` / `children_screen.dart` | 🟡 |
| 7.3 | thêm hồ sơ con (full form, image only) | `_showAddChildDialog` | 🔴 |
| 7.4 | thêm hồ sơ con - noti pháp lý | — | 🆕 |
| 7.5 | popup chuyển con xác nhận | — | 🆕 |
| 7.6 | popup con xác nhận | — | 🆕 |
| 7.7 | popup con đọc điều khoản | — | 🆕 |
| 7.8 | thêm hồ sơ con thành công | SnackBar | 🟡 |
| 8 | thông báo ("Tất cả" tab) | `notifications_screen.dart` | 🟡 |
| 8.1 | thông báo ("Quản lý con" tab) | `notifications_screen.dart` | 🟡 |

**Key gaps**
- **Child consent flow (7.4 → 7.5 → 7.6 → 7.7):** entirely new compliance journey (legal notice → transfer phone to child → child confirms → child reads terms). No Flutter screens exist.
- **Add-child form (7.3):** design is a **full screen** with avatar upload, **share-account username**, an auto-generated **profile code + QR**, and a legal note; Flutter is a basic `AlertDialog` with name/birthdate/gender only.
- **Tabbed account (7.1 / 7.2):** design separates "Thông tin tài khoản" and "Quản lý hồ sơ con" into **pill tabs**, shows **profile-code badges + QR per child**; Flutter is one scrollable screen with initials avatars.
- **7.8 success:** design is a full modal with illustration + age-phase tag ("Sơ sinh • 0–24 tháng"); Flutter uses a SnackBar.
- **Notifications (8 / 8.1):** design adds **filter tabs** (Tất cả / Quản lý con / Khác), **date grouping** (Hôm nay / Hôm qua), and colored icon circles; Flutter has a flat list, no tabs, no grouping.

---

## 3. Net-new work introduced by these updates (🆕 / 🔴)

Brand-new features with **no existing Flutter code**:

1. **Child legal-consent flow** — 4 screens (7.4, 7.5, 7.6, 7.7) + restructure 7.3 into a full screen.
2. **Height prediction** — input (4.8) + result (4.9).
3. **Article authoring** — write form (5.10), submit-success (5.11), write-permission header variant (5.1b).
4. **Library search** — results screen (5.3).
5. **Daily journal** (meals + sleep) — pop-up 3 (3.3).
6. **"All states" report dashboard** — 4.7.
7. **Practice notes form** — 4.2.
8. **Stepped registration with role-selection screen** — 6.2.
9. **Logged-out library state** — 5.2.
10. **Save/bookmark article** + success modal — 5.7.

---

## 4. Recommended priority order

**P0 — Compliance / blockers**
- Child consent flow (7.3–7.7). Legal gating for children 7+.

**P1 — Headline new features**
- Article authoring (5.1b, 5.10, 5.11) and library search (5.3).
- Height prediction (4.8, 4.9).

**P2 — Structural parity**
- Check-in tab restructure + "Điều ảnh hưởng" + Đo lường tab (3.x).
- Reports KPI cards + expert assessment + "all states" + WHO tables (4.3–4.8).
- Account tabs + add-child full form + profile code/QR (7.1–7.3).
- Notifications filter tabs + date grouping (8, 8.1).
- Child picker → full-screen grid (2).
- Stepped registration + confirm password (6.2, 6.3).

**P3 — Polish**
- Replace success/confirm SnackBars with modals (1.2, 1.4, 5.5–5.9, 7.8).
- Logged-out vs logged-in vs has-permission state handling (1.x, 5.x).
- Login gradient/centered styling (6.1), article-detail hero/author/related (5.4).

---

## 5. Notes & caveats
- `DESIGN.md` is identical boilerplate ("Gentle Guardian" design system) in every folder — it is **not** per-screen content; the real per-screen spec is `code.html` / `screen.png`.
- 7 folders ship only `screen.png` (no markup): 3.1 check-in, 3.2 sơ đồ, 4.5 chu kỳ, 4.6 cơ thể, 4.9 dự báo kết quả, 7.1 thông tin tk, 7.3 thêm hồ sơ con — these were assessed visually.
- Duplicate/renamed pairs to reconcile in `1. UI/`: `3.1 check in` vs `check in chung`; `4.8 WHO` vs `4.8 dự báo nhập`; `5.1 user login` vs `5.1 có quyền viết bài`; `8 thông báo` vs `8.1 thông báo`.
- Shared widgets live outside `lib/screens/` (e.g. `child_picker.dart` under `lib/shared/`).
</content>
</invoke>
