# UI directions (Phase 0)

The app works. It does not yet look like a finished finance app. This note is the audit and three looks to choose from. Nothing on the real screens was restyled. The three looks are fake Home and editor screens under **More → Developer tools → Design directions** (debug builds only).

Screenshots of the app as it is today: `docs/reviews/ui-audit/`.
Screenshots of the three looks: `docs/reviews/ui-directions/`.

Phone: Samsung A52, English and Bangla, light and dark, font scale 1.1.

## What is weak today

- **Home is empty.** One business card, then a large gray area, then a floating "New invoice" button. No greeting, no month totals, no overdue line, no recent invoices.
- **Two different greens.** Primary buttons are bottle green in light mode. The floating button is a pale mint, and the dark-mode Save button is a bright mint. They do not read as one accent.
- **Lists are flat.** Invoices, clients, and items are plain rows. There are no status filters, no "Due in 3 days" / "Overdue 5 days", and the amount is the same size as the name. A long Bangla name wraps to two lines and gets cut off (`মেসার্স রহমান…`).
- **The editor is a generic form.** Full-width outlined fields stacked under small section titles. The invoice-number field uses a document icon that looks like a calendar. The Save bar is solid, which is good, but the page above it has no clear totals moment.
- **Dark mode is readable and flat.** Text contrast is fine. Cards and the page are almost the same dark gray, so groups do not separate.
- **More is a short menu in a big empty page.** Settings, backup, templates, and payments are not on it yet. That is expected until the rest of the redesign.
- **PDF preview** shows the template and language chips, then a long wait on "Making the PDF…", then Share / Print / Save. The preview itself is fine once it appears.

Bangla digits, conjuncts, and the four-tab bar all hold. Nothing overflowed at the normal font size.

## Shared type

All three looks use the fonts already in the app: **Noto Sans** and **Noto Sans Bengali**, bundled, offline. Amounts stay tabular. A second family (a serif for Ledger, for example) means adding a font file, which needs a yes before Phase 1.

Icons stay the outlined Material set already in `AppIcons`. Gold is a highlight, never a button fill. Status always has a color and a word.

Changing the brand green (`#006A4E` / `#4CC9A0`) needs a yes. Only **Current** keeps that green exactly.

## 1. Ledger

Quiet paper ledger. Ink, hairlines, no shadow, no filled hero. Radius 10.

| | Light | Dark |
|---|---|---|
| Page | `#F6F4EF` | `#12110E` |
| Card | `#FFFCF8` | `#1C1A16` |
| Ink | `#1C1915` | `#F4F0E6` |
| Accent | `#0C3B2E` | `#8FCBB2` |
| Gold | `#B0893E` | `#E2C27A` |
| Paid | `#1B6B45` | `#7DCEA0` |
| Partially paid | `#8A5A12` | `#E0B15A` |
| Overdue | `#9F2D2D` | `#F0A0A0` |
| Draft | `#6F6A62` | `#A39E93` |
| Sent | `#1E4D7B` | `#8EB4E0` |

Home is three figures in a row (invoiced, received, outstanding) and an overdue line with a red left border. The editor is underline fields and a plain total.

## 2. Current

Closer to Wise or Revolut, and the closest to the green already in the app. Radius 20. A soft shadow in light mode only. One filled green hero.

| | Light | Dark |
|---|---|---|
| Page | `#F3F5F7` | `#0E1114` |
| Card | `#FFFFFF` | `#1A1F24` |
| Ink | `#101418` | `#F2F5F7` |
| Accent | `#006A4E` | `#3DDC97` |
| Gold | `#E0A100` | `#F5C542` |
| Paid | `#157A45` | `#3DDC97` |
| Partially paid | `#B45309` | `#F5C542` |
| Overdue | `#B42318` | `#FF8A80` |
| Draft | `#5C6770` | `#9AA3AB` |
| Sent | `#1D4ED8` | `#8EB4FF` |

Home leads with outstanding amount in a green block. The editor groups fields in rounded boxes and ends in a green total bar.

## 3. Atelier

More like Notion. Warm paper, more air, no shadow, no filled hero. Radius 16. A short greeting sits above the month.

| | Light | Dark |
|---|---|---|
| Page | `#EFEDE7` | `#161815` |
| Card | `#FBF9F4` | `#22261F` |
| Ink | `#24302A` | `#ECE8DF` |
| Accent | `#2F6D52` | `#8FCBAA` |
| Gold | `#A7842F` | `#E2C27A` |
| Paid | `#2F6D52` | `#8FCBAA` |
| Partially paid | `#8A6232` | `#E2C27A` |
| Overdue | `#8E3B3B` | `#F0B4B4` |
| Draft | `#667069` | `#A8A99A` |
| Sent | `#3D5A73` | `#B7C7D6` |

Home is the greeting, then the same three figures as Ledger, with softer color and more space. The editor uses quiet rounded fields and an outlined total.

## How to look

On the phone, debug build: **More → Design directions**. Switch Ledger / Current / Atelier, and Home / Editor. The phone theme and language drive light, dark, English, and Bangla. Sample amounts use Bangla digits when the app is in Bangla.

Phase 1 starts after one of these three is chosen.
