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
- **More.** Manrope and Plus Jakarta Sans side by side, grouped tiles, and a gold QuickBill Pro card.

## Font

Both Latin faces are bundled (OFL), work offline, and fall back to Noto Sans Bengali for Bangla. Manrope is applied until a sample on More is tapped. One of the two still needs a pick before Phase 1. Do not add a third family.

## Not started

Phase 1 (tokens and theme on the real screens) waits for an OK, and for the font pick.

The rejected sparse shots are still in `docs/reviews/ui-directions/`. The audit of the app as it ships today is in `docs/reviews/ui-audit/`.
