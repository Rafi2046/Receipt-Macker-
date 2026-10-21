# UI directions (Phase 0)

The first three looks were the same sparse layout in different colors. That set was rejected.

**Current** is the direction to build from (Wise / Revolut). Brand green stays `#006A4E` in light mode and `#3DDC97` in dark mode. Gold is a highlight only, on the Pro card, never a button fill.

The mock is a debug screen: **More → Developer tools → Design directions**. The real screens, totals, and database are unchanged. The numbers on it are demo data.

Screenshots: `docs/reviews/ui-directions/hifi/`.

Phone: Samsung A52. English in light and dark for Home, Invoices, the editor, invoice detail, Clients, and More. Bangla in light for Home and the editor. The shots are at font scale 1.0. Fitting at 1.3 is covered by the widget test.

## What is on the mock

- **Home.** Greeting, deep green hero with the outstanding amount counting up, invoiced and received, a "+12% vs last month" pill, a month switch, four round actions, a soft overdue banner, a six-month bar chart, and recent invoices.
- **Bottom bar.** Home, Invoices, a raised + for a new invoice, Clients, More. The active tab uses a filled icon, a label, and a tinted pill.
- **Invoices.** Search, status chips with counts, month groups, and swipe actions (mark paid, share, delete).
- **Editor.** Client, dates, items with swipe to delete, discount, tax, shipping, notes, and a sticky total with Save & preview.
- **Detail.** Status, amount, paid-versus-due bar, Preview PDF / WhatsApp / Record payment / More, and a payment timeline.
- **Clients.** Search, letter sections, outstanding per client.
- **More.** Manrope and Plus Jakarta Sans side by side, grouped tiles, and a gold QuickBill Pro card. Invoice design opens the template gallery. Invoice settings opens the defaults.

## Template gallery

Path: **More → Developer tools → Design directions → More → Invoice design**.

Twenty original combinations of layout, header, and palette. Categories are Recommended, Simple, Classic, Professional, and Creative. Each card is a real first page with sample data, including a long Bangla line. A gold PRO badge marks the Pro candidates. Every template can still be opened and used.

A tap opens the full preview: A4, Letter, 58 mm, and 80 mm. Eight lines fill two pages. On 58 mm and 80 mm the header stacks and the quantity line is hidden. **Use this template** only marks the choice inside the mock.

PDF export still prints Classic, Modern, and Minimal. Connecting a gallery choice to that export waits for an OK.

Shots: `19-gallery-light-en.png`, `20-preview-a4-light-en.png`, `21-preview-58-light-en.png`, `22-gallery-dark-en.png`, `23-preview-grove-dark-en.png`, `24-gallery-light-bn.png`, `25-preview-harbor-light-bn.png`.

## Invoice settings

Path: **More → Developer tools → Design directions → More → Invoice settings**. Separate from Invoice design.

These are the defaults for a new invoice. One invoice can use its own. The screen holds payment details, tax rate, added-on-top or included-in-the-price, a drawn signature, due terms (on receipt, 7, 15, 30 days), terms, default currency (BDT, USD, EUR), and four toggles: PAID stamp, total quantity, balance due, quantity and unit separately. Numbering has a prefix, the next number, and a choice to start again each year or never. The values stay in the mock until this screen is accepted.

Shots: `26-settings-light-en.png`, `27-settings-scrolled-light-en.png`, `28-settings-dark-en.png`, `29-settings-scrolled-dark-en.png`, `30-settings-light-bn.png`, `31-settings-scrolled-light-bn.png`.

## Font

Both Latin faces are bundled (OFL), work offline, and fall back to Noto Sans Bengali for Bangla. Manrope is applied until a sample on More is tapped. One of the two still needs a pick before Phase 1. Do not add a third family.

## Not started

The real app now uses this direction: Manrope, the bottle-green hero, and the floating bar with a raised + for a new invoice. Home shows what is owed, this month's invoiced and received, and the newest invoices. The first-invoice hint is still waiting. Plus Jakarta Sans is still bundled if the font should change.

The rejected sparse shots are still in `docs/reviews/ui-directions/`. The audit of the app as it ships today is in `docs/reviews/ui-audit/`.
