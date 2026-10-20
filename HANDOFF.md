# HANDOFF: QuickBill (Invoice & Receipt Maker)

> **For the next Claude session.** This file is written so you can continue
> this project with full context. Read it together with `CLAUDE.md`.
>
> **`CLAUDE.md` is the single source of truth.** Read it fully before every
> task. If anything here conflicts with `CLAUDE.md`, `CLAUDE.md` wins; ask the
> owner. This handoff adds what CLAUDE.md does not record: where the work
> stands, owner decisions made along the way, how we test on the phone, and
> lessons learned.
>
> Written 2026-10-20, at the end of milestone M5.

---

## 1. Who and what

- **Owner:** Rahat Rafi (IRR Dev Labs). Writes in English or romanized Bangla
  ("Banglish"). Answer in plain, short English (or match the owner's language
  if they ask). Support email: irrdevlabs.support@gmail.com.
- **App:** QuickBill, a Flutter invoice & receipt maker. Android first,
  offline, no backend. English + Bangla from day one. Default currency BDT.
- **Repo folder:** `/Users/rafi/StudioProjects/receipt_macker` (the folder name
  has a typo; the Dart package is `receipt_maker`).
- **App name:** QuickBill. Play Store title: "QuickBill: Invoice & Receipt".
  **Package id:** `com.rafi.quickbill` (final, permanent once published).

## 2. How the owner wants us to work

1. Read `CLAUDE.md` fully before every task.
2. **Stop after each milestone and wait for the owner's OK** before the next.
3. At the start of a milestone: if things are uncertain, give a short plan and
   ask. If the path is clear, proceed with sensible defaults and list every
   default decision in the summary so the owner can change it.
4. Each milestone ends with:
   - `./scripts/check.sh` passing (codegen, format, analyze, all tests);
   - testing on the owner's **Samsung A52** (light + dark, English + Bangla,
     2x font), with screenshots;
   - commits (`feat:` / `fix:` / `chore:` / `test:`, one logical change each,
     each commit must build on its own);
   - a **review page** (a claude.ai Artifact) with screenshots, decisions,
     fixes, and anything not done;
   - a short summary message: what was built, what was tested on the phone,
     default decisions, bugs found and fixed, what is left / needs the owner.
5. **Never push to `main`** without the owner's OK. Nothing has been pushed so
   far. Branches are stacked (see section 4).
6. Never add packages, change architecture or rename public ids without
   approval (packages listed in CLAUDE.md §2 are pre-approved).
7. Never mark something as tested if it was not run. Say clearly what could
   not be tested and why.
8. Commit trailer used in this project:
   `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`
9. **Privacy on the owner's phone:** never publish screenshots that show the
   owner's photos, contacts (e.g. the share sheet), wallpaper or other apps.
   Crop or skip them. Delete any test files you put on the phone (Downloads,
   Pictures) afterwards. Restore phone settings you changed (font scale is
   **1.1**, dark mode off, app language English).

## 3. Environment

- Flutter 3.47.6, Dart 3.13.5. macOS, shell is **zsh** (word splitting differs;
  put multi-arg scripts in bash files). macOS has no `timeout` command; use
  `flutter test --timeout 60s`.
- **Disk space is very low** (about 3.7 GB free). Builds need space. If space
  runs out, `spikes/pdf_spike/build` can be cleared with `flutter clean`
  inside `spikes/pdf_spike` (throwaway spike). Do not download emulator images
  without the owner freeing space first.
- **Phone:** Samsung A52 (SM-A525F, Android 14), serial `R58R92JYFCN`.
  Use `export ANDROID_SERIAL=R58R92JYFCN`. USB debugging is on.
- No emulators/AVDs exist.
- Headless Chrome (`/Applications/Google Chrome.app`) is used by
  `scripts/branding.sh` to render SVG to PNG.

### Scripts

- `scripts/check.sh`: codegen, format check, analyze, tests. Must pass before
  every commit.
- `scripts/gen.sh`: `flutter gen-l10n`, `build_runner`, and
  `drift_dev make-migrations` (after bumping the schema version, this snapshots
  the schema into `drift_schemas/` and regenerates migration steps and tests).
- `scripts/branding.sh`: renders the icon/splash PNGs from
  `assets/branding/*.svg` and runs flutter_launcher_icons +
  flutter_native_splash.

Generated files (`*.g.dart`, `*.freezed.dart`, `lib/l10n/gen/`) are
gitignored; run `scripts/gen.sh` after checkout.

## 4. Git state

Branches are stacked; each milestone branch was cut from the previous one.
Nothing is merged or pushed. Ask the owner how they want to merge to `main`.

```
main (origin) ← m0-setup ← m1-widgets ← m2-business-profile ← m3-clients-items
             ← m4-invoices ← m5-pdf   (current: m5-pdf, clean working tree)
```

## 5. Milestone status

| # | Milestone | Status | Review page |
|---|---|---|---|
| M0 | Setup + PDF spike | Done | https://claude.ai/artifact/NBEUDwKZ47ZE1k6FP9jh84 |
| M1 | Design system + shared widgets | Done | https://claude.ai/artifact/9D8ZfknyM3gxWX1AhG7giB |
| M2 | Business profile + onboarding | Done | https://claude.ai/artifact/NJoc4XiMf8b2mxByiv97MZ |
| M3 | Clients + items | Done | https://claude.ai/artifact/9kTtx4WEYcNkix3jgtfL6k |
| Branding | Name, package id, logo, icons, splash | Done | https://claude.ai/artifact/T4dLFi79oCUozTug8U6YZC |
| M4 | Invoice editor + calculator | Done | https://claude.ai/artifact/BT2gip4YpFH2vDDrec5jEq |
| M5 | PDF templates, preview, share, print | Done (one check open, see §8) | https://claude.ai/artifact/TYaVegdPbNG3S4CZVfJ6Fg |
| **M6** | **Payments + receipts + statuses** | **Next** | |
| M7 | Dashboard + settings + backup/restore | | |
| M8 | Monetization (ads, Pro, paywall) | | |
| M9 | Analytics, privacy, polish | | |
| M10 | Release prep | | |

`scripts/check.sh` passes with **256 tests** at the end of M5.

## 6. Owner decisions so far (keep these)

- **Brand:** bottle green & gold. Light: primary `#006A4E`, secondary
  `#E0A100`. Dark: primary `#4CC9A0`, secondary `#F5C542`.
  Source: `lib/app/theme/app_colors.dart`.
- **Logo:** concept A, a receipt with a torn edge and a gold lightning bolt.
  Editable SVGs in `assets/branding/` (see its README). Must never resemble
  QuickBooks.
- **PDF engine (M0):** HTML/CSS → PDF via our own Android WebView bridge
  (`HtmlPdfChannel.kt` + `android/print/PdfPrintBridge.java`). The `pdf` and
  Syncfusion packages break Bangla shaping. `printing` is only for raster
  preview and the print dialog. **Never use `Printing.convertHtml`**
  (deprecated, hangs on Android 14).
- **Approved packages beyond the core list:** flutter_launcher_icons,
  flutter_native_splash (dev). printing, share_plus, file_picker, image_picker,
  signature, shared_preferences are in the approved stack.
- No `google_fonts`: Noto Sans (Latin subset) + Noto Sans Bengali are bundled
  in `assets/fonts/`. `sqlite3_flutter_libs` was dropped (end of life with
  sqlite3 3.x).

### Defaults chosen by Claude and reported (owner has not objected)

- Onboarding: 3 steps (language, business details with name required +
  default currency, logo + finger-drawn signature, skippable).
- Clients: only name required. Items: name + unit price required (0 allowed);
  each item keeps its own currency; default tax optional (basis points).
- Delete only from editors, with confirmation.
- Invoice: one tax rate per invoice (exclusive or inclusive); invoice
  discount before tax; shipping not taxed; client optional (walk-in);
  quantities up to 3 decimals; due presets on receipt / 7 / 15 / 30 days /
  custom; first item sets invoice currency, later foreign-currency items ask
  for a price; changing currency keeps face value (no exchange rates).
- Numbers `INV-0001`, editable, unique per profile, never reused, hand-typed
  higher numbers move the sequence forward. Prefix/next number editable in
  Settings (M7).
- Status: Draft until "Mark as sent"; overdue = the day after the due date
  (phone's time zone) with a balance; Paid / Partially paid come from payments
  (logic exists in `InvoiceStatusResolver`, needs M6 data).
- PDF: 3 designs (Classic, Modern, Minimal), all free for now; last design
  remembered; PDF language starts as the app's, switchable EN/BN; A4 (Letter
  supported in code, needs a setting); after sharing a draft the app *asks*
  "Mark as sent?".

### Still to decide by the owner (remind them)

- Free plan limit N on clients/items (CLAUDE.md §9.1), before M8.
- "Made with QuickBill" footer on Free PDFs: yes/no (§9.1).
- Which templates are Free vs Pro (M8).
- Subscription product ids are *proposed* as `quickbill_pro_monthly` /
  `quickbill_pro_yearly`; confirm before creating them in Play Console.
- How to merge the stacked branches into `main`, and when to push.

## 7. Architecture notes (beyond CLAUDE.md §3)

- **Feature barrels:** other features import only
  `features/business_profile/business_profile.dart`,
  `features/clients/clients.dart`, `features/items/items.dart` (public API).
- **Result/Failure:** repositories return `Result<T>`; `Failure` is sealed
  (`DatabaseFailure`, `StorageFailure`, `ValidationFailure(field)`,
  `NotFoundFailure`, `PdfFailure`, `UnexpectedFailure`). Views map failures to
  localized text with `l10n.messageFor(failure)`.
- **Riverpod retry:** Riverpod 3 retries failed providers by default. We use
  `appProviderRetry` (`lib/app/provider_retry.dart`) so `Failure`s are never
  retried in the background. Use it in every `ProviderScope` /
  `ProviderContainer`, tests included.
- **Money:** `lib/core/utils/money.dart`, integer minor units, `BigInt`
  half-up scaling, saturates at 15 digits (`Money.maxMinor`). Quantities are
  thousandths (`quantityMilli`); percentages are basis points.
- **Dates:** issue/due dates are `CalendarDate` (date-only, stored as
  `yyyymmdd` int) so they never shift by a day. Timestamps are UTC.
- **Clock:** `clockProvider` (`lib/core/services/clock.dart`); override in
  tests to fix "today".
- **Database:** Drift, schema **v4** (business_profiles, clients, items,
  invoices, invoice_lines, invoice_numbering). Every schema change: bump
  `schemaVersion`, add a `fromNToM` step in `app_database.dart`, run
  `scripts/gen.sh` (make-migrations), add a data migration test in
  `test/core/database/migrations/app_database/data_migration_test.dart`.
- **Invoice editor:** `InvoiceEditorViewModel` (family: `invoiceId`,
  `copyOf`); line intents live in the part file `invoice_line_editing.dart`;
  pure edits in `domain/logic/invoice_drafting.dart`; totals from
  `InvoiceCalculator` (rounding order documented there).
- **PDF:** `core/services/pdf/` holds the converter, fonts, `PdfDocument`
  model, `PdfHtml` helpers (everything user-typed is escaped) and the three
  templates. `features/invoices/data/mappers/invoice_pdf_mapper.dart` turns an
  invoice into a `PdfDocument`; `InvoicePdfRepositoryImpl` renders to
  `cache/pdf/<number>.pdf`. Preview widgets in `core/widgets/pdf/` are meant
  to be reused by receipts in M6.
- **Shared form frame:** `EditorScaffold` (Save bar above the keyboard,
  Delete action, "Discard changes?" guard). `SearchableList` for list screens.
- **Inputs:** `AmountField` (minor units), `DecimalField` (scaled ints,
  follows outside value changes without disturbing typing), `PercentField`.
- **Debug-only tools** on the home screen (kDebugMode): theme preview (also
  used to switch app language EN/BN quickly), widget gallery, "Add sample
  invoices" (40-line English invoice + Bangla invoice with conjuncts).

## 8. Open items carried forward

- **PDF bridge retest on oldest (API 24, Android 7) and newest Android** —
  required by CLAUDE.md §2.1, not done because the Mac lacks disk space for
  emulators. Only tested on Android 14 (A52). The system print dialog fallback
  works. Ask the owner to free ~8 GB or test on old/new phones.
- Known minor: if you tap Save while typing in a field that then shows an
  error, the error line can sit under the Save bar until the keyboard closes.
- Two files are above ~200 lines (under the 300 hard limit):
  `invoice_editor_view_model.dart` (243), `line_item_sheet.dart` (238).
- `HomeView` is temporary until the M7 dashboard (bottom navigation comes then).
- The home "PDF and sharing come next" card text is outdated after M5; update
  it (or replace with the dashboard in M7).

## 9. NEXT: M6 — Payments + receipts + statuses

"Done when: partial payments, overdue, receipt PDF" (CLAUDE.md §14).

Suggested plan (confirm defaults with the owner in the summary):

1. **Data:** `payments` table (id, invoice_id FK cascade, amount_minor,
   paid_on CalendarDate, method, note, created/updated UTC) and receipt
   numbering (e.g. `RCPT-0001`, never reused, its own numbering row like
   `invoice_numbering`). Schema v5 + migration + data migration test.
   Consider storing `paid_minor` on invoices (like `total_minor`) for fast
   lists, recomputed on every payment change.
2. **Domain:** `Payment` model, `PaymentMethod` enum (cash, bKash, Nagad,
   Rocket, bank transfer, card, other — confirm list), validator (amount > 0,
   not more than the balance unless the owner wants overpayments), repository
   interface. `InvoiceCalculator.calculate(invoice, paidMinor:)` and
   `InvoiceStatusResolver` already handle paid / partial / overdue.
3. **UI:** "Record payment" on the invoice detail (sheet with amount
   prefilled with the balance, date, method, note); payments list on the
   detail with edit/delete; invoice list and detail statuses show Paid /
   Partially paid; totals show Paid and Balance due (`TotalsSummary` already
   supports it).
4. **Receipts:** a receipt PDF per payment, reusing `core/services/pdf`
   (`PdfDocument` has `stamp` and `afterTotal`), the preview widgets and the
   share/print/save services. Receipt title, receipt number, "received from",
   amount in figures, payment method, invoice reference, balance after this
   payment. EN/BN strings, Bangla digits.
5. **Tests:** calculator/status with payments, repository (cascade, numbering),
   ViewModels with mocks, full-app flow (record partial → Partially paid,
   record rest → Paid, overdue with a fixed clock), receipt PDF mapper EN/BN.
6. **Phone:** record payments, check statuses, make/share a receipt PDF,
   Bangla/dark/2x, pull PDFs and render them on the Mac (see §10).

After M6: M7 (dashboard with this month's totals, settings screen incl.
default tax, due days, invoice prefix/next number, currency list, backup &
restore round trip), M8 (AdMob with caps, Pro subscription, paywall, welcome
screen, restore), M9 (Firebase Analytics/Crashlytics events only, privacy
policy, accessibility pass), M10 (signing, store listing, Data safety).

## 10. Testing on the phone (how we did it)

Build and install a debug APK, then drive the app with adb:

```bash
export ANDROID_SERIAL=R58R92JYFCN
flutter build apk --debug && adb install -r build/app/outputs/flutter-apk/app-debug.apk
adb shell am force-stop com.rafi.quickbill
adb shell monkey -p com.rafi.quickbill -c android.intent.category.LAUNCHER 1
```

Helpers we used (recreate in your scratchpad; source them in bash):

```bash
dump() { adb shell uiautomator dump /sdcard/u.xml >/dev/null 2>&1; adb exec-out cat /sdcard/u.xml | tr '>' '\n'; }
texts() { dump | grep -oE '(text|content-desc)="[^"]+"' | sed 's/^[a-z-]*=//' | tr '\n' '|'; echo; }
shot() { sleep "${2:-1}"; adb exec-out screencap -p > "$OUT/$1.png"; }
type() { adb shell input text "$(printf '%s' "$1" | sed 's/ /%s/g')"; }
# tapText <regex> [nth]: use a small Python script to find the node's bounds
#   (macOS grep fails on some Bangla text; Python regex works).
#   Note dump() splits on '>' so match nodes with r'<node [^\n]*'.
# tapField <n>: tap the nth android.widget.EditText.
```

Lessons:
- Flutter text fields have no label in the uiautomator dump; tap them by
  position (`tapField`). Fields off-screen are not in the dump: scroll first.
- `&` shows as `&amp;` in dumps.
- **Do not tap near the keyboard's suggestion strip** — it can paste the
  owner's clipboard into a field. Close the keyboard (`keyevent 4` or `111`)
  before tapping the next field.
- `keyevent 111`/`4` also closes bottom sheets; inside sheets use `keyevent 66`
  (Done) for numeric fields.
- Switch app language via Developer tools → Theme preview.
- Dark mode: `adb shell cmd uimode night yes|no`. Font:
  `adb shell settings put system font_scale 2.0` (restore **1.1**).
- Pull a generated PDF (debug builds only):
  `adb exec-out run-as com.rafi.quickbill cat cache/pdf/INV-0003.pdf > file.pdf`.
  Render pages on the Mac with a small Swift/PDFKit script (render each page to
  PNG at 2.5x) to check layout, Bangla shaping and page breaks.
- The share sheet shows the owner's contacts: dismiss it, never screenshot it
  for the review page.
- Test data currently on the phone (QuickBill app): business "Rahman Traders"
  with a sample logo and signature, client Karim Store, items Logo design and
  Consulting, invoices INV-0001 (sent), INV-0003 (40 lines), INV-0004 (Bangla).
  An old dev app `com.rafi.appname` (pre-rename) and `com.rafi.pdf_spike` are
  also installed; leave them unless the owner says otherwise.

## 11. Quick start for the next session

```bash
cd /Users/rafi/StudioProjects/receipt_macker
git status && git log --oneline -5       # expect branch m5-pdf, clean
./scripts/gen.sh && ./scripts/check.sh   # expect "All checks passed", 256 tests
```

Then read `CLAUDE.md`, confirm with the owner, and start M6 on a new branch
`m6-payments` cut from `m5-pdf`.
