# CLAUDE.md: Invoice & Receipt Maker (Flutter)

> This file is the single source of truth for how this app is built.
> Read it fully before every task. If a request conflicts with this file, stop and ask.
> Owner: Rahat Rafi (IRR Dev Labs). Android first (Google Play). Offline-first: no backend, no server cost.

---

## 0. Placeholders the owner fills in

| Key | Value |
|---|---|
| App name | QuickBill (home screen). Play Store title: "QuickBill: Invoice & Receipt" |
| Package id | `com.rafi.quickbill` (permanent once published) |
| Developer / publisher | IRR Dev Labs |
| Support email | irrdevlabs.support@gmail.com |
| Brand colors | Bottle green & gold (decided M0). Light: primary `#006A4E`, secondary `#E0A100`. Dark: primary `#3DDC97`, secondary `#F5C542`. Source of truth: `app/theme/app_colors.dart` |
| Logo / app icon | Concept A, receipt with a lightning bolt (owner pick). Source SVGs in `assets/branding/`; regenerate icons and splash with `scripts/branding.sh` |
| Languages | English + Bangla (from day one) |
| Default currency | BDT (৳), user can change; every currency supported |

Never invent values for these. If one is missing, use an obvious placeholder and list it in your summary.

---

## 1. Product

### 1.1 One-line pitch
Create professional invoices and payment receipts in under a minute, offline, and send them as PDF on WhatsApp or email.

### 1.2 Target users
Freelancers, small shops, online (Facebook/Instagram) sellers, service providers (repair, tutoring, design), small agencies. Global audience; first-class Bangla support is a differentiator.

### 1.3 MVP scope (v1.0). Build ONLY this first.
1. **Business profile**: name, logo, address, phone, email, website, tax/VAT/BIN number, payment instructions (bank details, mobile banking number as plain text), default notes/terms, signature image. One profile in Free.
2. **Clients**: create/edit/delete/search; name, phone, email, address, notes.
3. **Items catalog**: saved products/services with name, description, unit, unit price, default tax. Pick items into an invoice quickly.
4. **Invoices**: create/edit/duplicate/delete.
   - Auto number with prefix (e.g. `INV-0001`), editable, must stay unique.
   - Issue date, due date (presets: on receipt, 7/15/30 days).
   - Line items: name, description, qty, unit, unit price, line discount (optional).
   - Invoice-level discount (percent or flat), tax (percent, inclusive or exclusive), shipping/extra charge.
   - Currency per invoice.
   - Notes, terms, payment instructions (prefilled from profile).
   - Status: Draft, Sent, Partially paid, Paid, Overdue (overdue computed from due date).
5. **Payments**: record full/partial payments (date, amount, method, note). Balance due updates automatically.
6. **Receipts**: generate a payment receipt PDF for a recorded payment.
7. **PDF**: 3 templates at launch (1 free + 2 Pro, final split is an owner decision). Live preview, share (WhatsApp, email, any app), print, save to device.
8. **Dashboard**: totals for this month: invoiced, paid, outstanding, overdue count; recent invoices.
9. **Settings**: language (EN/BN), theme (system/light/dark), currency, number format, default tax, default due days, invoice prefix and next number, business profile, backup/restore, privacy policy, terms, support, rate app.
10. **Backup & restore**: export all data to a single file (share to Google Drive/email/files) and restore from it. Offline apps must protect users from losing data when they change phones.
11. **Monetization**: AdMob + Pro subscription (see section 9).
12. **Analytics**: Firebase Analytics + Crashlytics (events only, never personal or invoice data).

### 1.4 Later (v1.1+). Do NOT build unless asked.
Estimates/quotations (convert to invoice), recurring invoices, multiple business profiles, expense tracking, reports export to Excel/CSV, client statements, custom template colors/fonts, more templates, home-screen widget, reminders for due invoices (local notifications), QR code with payment info on the invoice.

### 1.5 Non-goals
No accounts, no login, no cloud sync, no server, no online payments inside the app.

---

## 2. Tech stack

Use these unless the owner approves a change. Use the latest stable versions that work together; check compatibility before adding.

| Concern | Package |
|---|---|
| State management / ViewModels | `flutter_riverpod` (+ `riverpod_annotation`, `riverpod_generator`) |
| Immutable models | `freezed`, `json_serializable` |
| Local database | `drift` (SQLite) + `sqlite3_flutter_libs` |
| Navigation | `go_router` |
| PDF | HTML/CSS templates printed to PDF by the Android System WebView through our own native bridge (decided M0, see 2.1). No Dart PDF library for generation |
| Printing / preview | `printing` for raster preview, print and share only. Never `Printing.convertHtml` (deprecated, hangs on Android 14) |
| Share | `share_plus` |
| Images (logo, signature) | `image_picker`, `signature` |
| Files | `path_provider`, `file_picker` (restore) |
| Localization | Flutter `gen-l10n` (`intl`, ARB files) |
| Ads | `google_mobile_ads` + UMP consent |
| Purchases | `in_app_purchase` (Play Billing Library 8+ required) |
| Analytics / crashes | `firebase_core`, `firebase_analytics`, `firebase_crashlytics` |
| Prefs (small flags only) | `shared_preferences` |
| Testing | `flutter_test`, `mocktail` |
| App icon / splash (dev only) | `flutter_launcher_icons`, `flutter_native_splash`, run by `scripts/branding.sh` |

Never add another package without asking the owner first, with a one-line reason.

### 2.1 Phase 0 PDF spike (mandatory before building PDF features)
Bangla is a complex script (conjuncts like ক্ষ, ন্দ্র). Some Dart PDF libraries don't shape it correctly and produce broken text.
1. Build a tiny test PDF with Bangla + English + `৳` + numbers using the candidate libraries (e.g. `pdf`, `syncfusion_flutter_pdf`), with an embedded Bangla font (e.g. Noto Sans Bengali / Hind Siliguri, check the font license).
2. Open it on a phone and in a desktop viewer. Show the owner screenshots.
3. Check each library's license for commercial use.
4. Recommend one library with reasons. Wait for approval.

**Result (M0, approved by owner):** `pdf` and `syncfusion_flutter_pdf` both break Bangla (no Indic shaping). Chosen: HTML → PDF via an attached, invisible Android WebView (`createPrintDocumentAdapter`), ~100 lines of Kotlin/Java owned by us. Fonts (Noto Sans + Noto Sans Bengali) are embedded in the HTML. The bridge uses a class in the `android.print` package to reach package-private callbacks: re-test it on the oldest and newest supported API level in M5 and keep the system print dialog as a fallback. Details and screenshots: `spikes/pdf_spike/SPIKE_REPORT.md`.

---

## 3. Architecture: MVVM, feature-first

```
View (widgets)  →  ViewModel (Riverpod Notifier)  →  Repository (interface)  →  Data source (Drift DAO / files)
     ↑ watches state                ↑ uses pure domain logic (calculators, validators)
```

### 3.1 Layer rules (strict)
- **View** (`presentation/views`, `presentation/widgets`): only UI. Reads state from a ViewModel provider, sends user intents to it. No business logic, no database calls, no calculations, no `try/catch` around data calls.
- **ViewModel** (`presentation/view_models`): a Riverpod `Notifier`/`AsyncNotifier` per screen. Holds screen state (a `freezed` state class), validates input, calls repositories and domain logic, exposes intents as methods (`addItem()`, `save()`). **Never** imports `package:flutter/material.dart` or takes a `BuildContext`.
- **Domain** (`domain/`): models (entities) and pure logic (e.g. `InvoiceCalculator`), plus repository **interfaces**. Pure Dart, no Flutter, no Drift. 100% unit tested.
- **Data** (`data/`): repository implementations, Drift tables/DAOs, mappers between DB rows and domain models, file/PDF/share services.
- Dependencies point inward only: View → ViewModel → Domain ← Data. Domain never imports Data or Flutter.
- Cross-feature access goes through providers of repository interfaces, never by importing another feature's internals.

### 3.2 Folder structure

```
lib/
  main.dart                       # bootstrap only (init Firebase, ads, run app)
  app/
    app.dart                      # MaterialApp.router, theme, l10n
    router/app_router.dart        # go_router routes
    router/route_names.dart
    theme/app_theme.dart          # builds ThemeData light + dark from tokens
    theme/app_colors.dart         # ThemeExtension with semantic colors
    bootstrap.dart
  core/
    constants/
      app_spacing.dart
      app_radius.dart
      app_sizes.dart              # icon sizes, button heights, max widths
      app_text_styles.dart
      app_durations.dart
      app_images.dart             # asset paths only
      app_icons.dart              # icon choices used app-wide
      app_constants.dart          # limits, defaults, store ids, URLs, support email
    database/
      app_database.dart
      tables/ ...                 # one table per file
      daos/ ...                   # one DAO per file
    services/
      pdf/ ...                    # pdf builder + one file per template
      share_service.dart
      backup_service.dart
      ads/ ...                    # ad ids, ad service, frequency caps
      purchases/ ...              # pro status, products, restore
      analytics_service.dart
    utils/
      money.dart                  # Money value type (minor units)
      formatters.dart             # currency/date/number formatting (Bangla digits)
      validators.dart
      extensions/ ...
    errors/
      failure.dart
      result.dart
    widgets/                      # shared, reusable, feature-agnostic widgets
      buttons/ app_button.dart, app_icon_button.dart
      inputs/ app_text_field.dart, amount_field.dart, date_field.dart, dropdown_field.dart
      layout/ app_scaffold.dart, section_header.dart, app_card.dart, app_divider.dart
      feedback/ empty_state.dart, error_view.dart, loading_view.dart, app_snackbar.dart, confirm_dialog.dart
      display/ amount_text.dart, status_chip.dart, avatar_initials.dart
  features/
    onboarding/
    business_profile/
    clients/
    items/
    invoices/
    payments/
    receipts/
    dashboard/
    settings/
    backup/
    paywall/
  l10n/
    app_en.arb
    app_bn.arb
test/                             # mirrors lib/ structure
assets/
  images/  icons/  fonts/
```

Each feature:

```
features/invoices/
  domain/
    models/invoice.dart, line_item.dart, invoice_status.dart
    logic/invoice_calculator.dart, invoice_number_generator.dart
    repositories/invoice_repository.dart        # abstract interface
  data/
    repositories/invoice_repository_impl.dart
    mappers/invoice_mapper.dart
  presentation/
    view_models/invoice_list_view_model.dart
    view_models/invoice_editor_view_model.dart
    view_models/invoice_editor_state.dart       # freezed
    views/invoice_list_view.dart
    views/invoice_editor_view.dart
    views/invoice_detail_view.dart
    widgets/invoice_list_tile.dart
    widgets/line_item_row.dart
    widgets/totals_summary.dart
    widgets/client_picker_sheet.dart
  providers.dart                                # wires repository + view models
```

### 3.3 Example: the MVVM pattern to follow

```dart
// domain/repositories/client_repository.dart
abstract interface class ClientRepository {
  Stream<List<Client>> watchAll({String query = ''});
  Future<Result<Client>> save(Client client);
  Future<Result<void>> delete(String id);
}

// presentation/view_models/client_list_view_model.dart
@riverpod
class ClientListViewModel extends _$ClientListViewModel {
  @override
  Stream<List<Client>> build() =>
      ref.watch(clientRepositoryProvider).watchAll(query: ref.watch(clientSearchQueryProvider));

  Future<Result<void>> delete(String id) =>
      ref.read(clientRepositoryProvider).delete(id);
}

// presentation/views/client_list_view.dart
class ClientListView extends ConsumerWidget {
  const ClientListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clients = ref.watch(clientListViewModelProvider);
    return AppScaffold(
      title: context.l10n.clientsTitle,
      body: clients.when(
        data: (list) => list.isEmpty ? const ClientsEmptyState() : ClientList(clients: list),
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView.fromError(e),
      ),
    );
  }
}
```

---

## 4. Design system (no hardcoded values in widgets)

### 4.1 Rules
- **Never** write raw colors (`Color(0xFF...)`, `Colors.blue`), raw numbers for spacing/radius/sizes, raw `TextStyle(...)`, raw asset paths or user-facing strings inside widgets.
- Use: `AppSpacing`, `AppRadius`, `AppSizes`, `context.textStyles` / `AppTextStyles`, `context.appColors` (ThemeExtension), `AppImages`, `AppIcons`, `context.l10n`.
- Every screen must look correct in **light and dark** mode. Colors come from the theme, never fixed.
- Support large system font sizes without overflow.

### 4.2 Tokens (implement exactly this shape; values may be tuned)

```dart
// core/constants/app_spacing.dart
abstract final class AppSpacing {
  static const double xxs = 2, xs = 4, sm = 8, md = 12, lg = 16, xl = 20, xxl = 24, xxxl = 32;
  static const double pagePadding = 16;
  static const double sectionGap = 24;
}

// core/constants/app_radius.dart
abstract final class AppRadius {
  static const double sm = 8, md = 12, lg = 16, pill = 999;
  static const BorderRadius card = BorderRadius.all(Radius.circular(md));
}

// core/constants/app_images.dart
abstract final class AppImages {
  static const String _base = 'assets/images';
  static const String logo = '$_base/logo.png';
  static const String emptyInvoices = '$_base/empty_invoices.png';
}
```

```dart
// core/constants/app_text_styles.dart  (registered in ThemeData.textTheme)
// Roles: displaySm, titleLg, titleMd, titleSm, bodyLg, bodyMd, bodySm, labelLg, labelMd, labelSm, amountLg, amountMd
// Fonts: one family that supports Latin + Bangla well (e.g. Hind Siliguri or Noto Sans Bengali) via google_fonts
// bundled as assets (no runtime download, the app must work offline).
// Amounts use tabular figures so numbers line up.

// app/theme/app_colors.dart
@immutable
class AppColors extends ThemeExtension<AppColors> {
  // semantic names only: primary, onPrimary, surface, surfaceAlt, border, textPrimary, textSecondary,
  // success (paid), warning (partial), danger (overdue), info (sent), neutral (draft)
  ...
}
extension AppThemeX on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
  TextTheme get textStyles => Theme.of(this).textTheme;
}
```

Status colors are semantic and identical across the app: Draft = neutral, Sent = info, Partially paid = warning, Paid = success, Overdue = danger. Never encode status by color alone; always show a label too.

### 4.3 Reusable widgets
- Before writing any UI, check `core/widgets/` and the feature's `widgets/`. Reuse; don't duplicate.
- If the same UI appears twice, extract it into a widget.
- Feature-specific widgets live in `features/<x>/presentation/widgets/`. Generic ones live in `core/widgets/`.
- Widgets take data and callbacks via constructor parameters; they don't read ViewModels unless they are a screen section that clearly owns that state.
- Use `const` constructors everywhere possible.

---

## 5. Code size and style rules (strict)

- **One public class/widget per file.** File name = class name in snake_case.
- **Max ~200 lines per file** (hard limit 300). If a file grows, split it.
- **`build()` max ~60 lines.** Extract sections into private `StatelessWidget` classes (prefer classes over `_buildX()` methods).
- Functions max ~40 lines; no deep nesting (max 3 levels), use early returns.
- No `print`; use a small logger that is silent in release.
- No `!` null assertions except where truly guaranteed; prefer pattern matching.
- No `dynamic` unless unavoidable.
- `flutter analyze` must be clean (use `flutter_lints` or `very_good_analysis`, owner's choice; default `flutter_lints` + stricter rules in `analysis_options.yaml`).
- Generated files (`*.g.dart`, `*.freezed.dart`) are committed or ignored consistently; run `dart run build_runner build --delete-conflicting-outputs` after model/provider changes.
- Naming: `*View` (screens), `*ViewModel`, `*State`, `*Repository` / `*RepositoryImpl`, `*Dao`, `*Table`, `*Service`.

---

## 6. Money, numbers and dates (critical for an invoice app)

- **Store money as integers in minor units** (e.g. poisha/cents) with a currency code. Never use `double` for money in storage or calculations.
- A `Money` value type handles add/subtract/multiply-by-quantity/percent with explicit rounding (half-up) at defined points: per line total, then discount, then tax, then grand total. Document the order in `InvoiceCalculator` and test it.
- Currencies with 0 decimals (e.g. JPY) must work.
- Tax inclusive vs exclusive must both be correct.
- Display formatting goes through `formatters.dart` using `intl`, respecting the app language: Bangla UI shows Bangla digits (০১২৩…) and English UI shows Latin digits, everywhere (lists, PDF, notifications). Add tests for this.
- A whole amount hides the trailing fraction (`৳26,500`, Bangla `৳২৬,৫০০`). A fractional amount keeps its decimals (`৳1,234.50`, `৳0.05`). Zero-decimal currencies (JPY) stay whole.
- Dates are stored in UTC, displayed in local time. Overdue = due date (local, end of day) passed and balance > 0.
- Invoice numbers are unique per profile; deleting an invoice never reuses its number automatically.

---

## 7. Data & storage

- Drift database, versioned with migrations. Every schema change = new version + migration + migration test.
- Images (logo, signature) are stored as files in the app documents directory; the DB stores relative paths.
- Repositories expose `Stream`s for lists so the UI updates automatically.
- Backup file: a single `.zip` (or similar) containing the DB export (JSON) + images + a manifest with app version and schema version. Restore validates the file first and asks for confirmation before replacing data.
- No data leaves the device except when the user shares/exports.

---

## 8. Errors, loading, empty states

- Repositories return `Result<T>` (success/failure); no exceptions leak into Views.
- Every list screen has: loading state, empty state (with a clear first action, e.g. "Create your first invoice"), error state with retry.
- User-facing errors are localized, short, and say what to do next.
- Destructive actions (delete invoice/client, restore backup) need an in-app confirmation dialog.

---

## 9. Monetization rules

### 9.1 Pro subscription
- Products: `quickbill_pro_monthly`, `quickbill_pro_yearly` (proposed) (Google Play subscriptions, free-trial offer configured in Play Console). Ids are final once created; confirm with the owner.
- Paywall: shows real store prices and trial terms ("X days free, then <price>/<period>, cancel anytime in Google Play"), Restore purchases, Terms and Privacy links. Works in light and dark mode.
- The price the customer is actually billed (for example `৳4,200/year`) is the largest price on the paywall. A per-week or per-month breakdown, if shown, is smaller type under that price.
- No countdown timers and no "limited offer" banners.
- The paywall includes a clear Free vs Pro comparison table.
- After purchase: a "Welcome to Pro" screen listing what was unlocked and a "Manage subscription" link.
- Pro status is cached locally and re-checked with Google Play on app start (works offline after first check).
- Free vs Pro split is an **owner decision**. Proposed default (confirm before building):

| Feature | Free | Pro |
|---|---|---|
| Invoices / receipts | Unlimited | Unlimited |
| PDF templates | 1 | All |
| Logo on invoice | Yes | Yes |
| Small "Made with QuickBill" footer on PDF | `[DECISION: yes/no]` | Removed |
| Clients / items | Up to `[N]` | Unlimited |
| Backup & restore | Manual | Manual + reminders |
| Ads | Yes | None |

### 9.2 Ads
- Banner: only on list screens (invoice list, clients, items), never on the invoice editor, PDF preview, paywall or settings.
- Interstitial: at most after a completed export/share, with caps (none on day one, max once per 5 completed exports, min 3 minutes apart). Configurable in `AppConstants`.
- Rewarded (optional, owner decision): e.g. use a Pro template once.
- Test ad unit IDs in debug; real IDs only via `--dart-define` in release.
- Ads never block the user's work; if an ad fails to load, continue without it.
- No ads at all for Pro users.

---

## 10. Localization & accessibility

- Every user-facing string lives in ARB files (EN + BN), including PDF labels ("Invoice", "Due date", "Total"), error messages and notifications.
- The PDF language follows a per-invoice or app setting (owner decision; default = app language).
- Tap targets ≥ 48dp, screen reader labels on icon buttons, contrast WCAG AA in both themes.

---

## 11. Analytics & privacy

- Firebase Analytics events only: `invoice_created`, `invoice_exported` (template id), `payment_recorded`, `receipt_created`, `backup_exported`, `paywall_viewed` (source), `pro_purchased`, `pro_restored`. No names, amounts, client data, phone numbers or emails in any event or crash log.
- Crashlytics on in release only.
- Privacy policy must state: data stays on device, backups are user-controlled files, AdMob + Firebase usage, Google Play purchases, no account.

---

## 12. Testing (definition of quality)

- **Unit tests (required):** `InvoiceCalculator` (discounts, tax inclusive/exclusive, rounding, zero-decimal currencies, partial payments, overdue), `Money`, formatters (Bangla digits), invoice numbering, validators, backup serialize/restore round-trip.
- **ViewModel tests:** with mocked repositories (`mocktail`).
- **Database tests:** in-memory Drift for DAOs and migrations.
- **Widget tests:** key shared widgets and main screens' empty/loading/error states.
- **PDF check:** generate each template with a long invoice (30+ items, multi-page), Bangla text, long names; open and verify visually.

---

## 13. How Claude must work on this project

### 13.1 Workflow for every task
1. Read this file and the relevant feature folder first.
2. Give a short plan (files to create/change). For anything big or uncertain, wait for the owner's OK.
3. Implement in small steps that each compile.
4. Run `flutter analyze` and `flutter test`; fix everything.
5. If UI changed: run on the connected phone, check light + dark + Bangla + large font, take screenshots.
6. Commit with a clear message (`feat: ...`, `fix: ...`, `refactor: ...`, `test: ...`, `chore: ...`). One logical change per commit. Never push to `main` without the owner's OK.
7. Summarize: what changed, what was tested, anything left or decided.

### 13.2 Always
- Follow sections 3–6 strictly. If you think a rule should change, propose it; don't silently break it.
- Keep files small and widgets reusable.
- Ask instead of guessing when product behavior is unclear.

### 13.3 Never
- Never put business logic in widgets or Flutter imports in domain/view models.
- Never hardcode colors, spacing, text styles, asset paths or strings in widgets.
- Never use `double` for money.
- Never add packages, change architecture, or rename public ids/product ids without approval.
- Never commit secrets, keystores, `key.properties`, real ad unit IDs, or `google-services.json` changes without saying so.
- Never mark something as tested if it wasn't run.

---

## 14. Milestones (stop after each and wait for the owner)

| # | Milestone | Done when |
|---|---|---|
| M0 | Project setup + PDF spike | Folder structure, tokens, theme (light/dark), l10n EN/BN, router, Drift skeleton, analysis rules, CI-like scripts; PDF library chosen with Bangla screenshots |
| M1 | Design system + shared widgets | All `core/widgets` built with a debug "widget gallery" screen to review them |
| M2 | Business profile + onboarding | First-run flow saves profile, logo, signature |
| M3 | Clients + items | CRUD, search, empty states, tests |
| M4 | Invoice editor + calculator | Create/edit/duplicate, totals correct, full unit tests |
| M5 | PDF templates + preview/share/print | 3 templates, multi-page, Bangla OK |
| M6 | Payments + receipts + statuses | Partial payments, overdue, receipt PDF |
| M7 | Dashboard + settings + backup/restore | Round-trip backup tested |
| M8 | Monetization | Ads with caps, Pro paywall, welcome screen, restore |
| M9 | Analytics, privacy, polish | Firebase, legal pages, accessibility pass |
| M10 | Release prep | Signing, store listing draft, Data safety answers, release build smoke test on phone |
