# QuickBill project status

Written 2026-10-21, after the M6 phone pass. `CLAUDE.md` is how the app is
built. `HANDOFF.md` is the session handoff. This file is the short snapshot.

## Where the code is

| Branch | What it holds | On GitHub? |
|---|---|---|
| `main` | M0 through M5 | Yes. `origin/main` is `bc6b62b` |
| `m6-payments` | `main` plus payments, receipts, and the Save-bar fix | Pushed as a backup after this pass. Not merged. |

Every commit is authored by Rafi2046. There is no co-author trailer.

## Milestones

| # | Milestone | Condition |
|---|---|---|
| M0–M5 | Setup through PDF | Done. On `main`. |
| M6 | Payments, receipts, statuses | Done on `m6-payments`. Phone-tested on the A52. Review: `docs/reviews/M6.md`. |
| M7 | Dashboard, settings, backup | Not started. Drawings are in `docs/plans/m7-mockups.html`. Waiting for approval. |
| M8–M10 | Ads, Pro, analytics, release | Not started. |

## Phone data

INV-0001 (Karim Store) is now Paid: ৳2,000 and ৳6,637, both cash, on 21 Oct 2026.
The second receipt is RCPT-0002. INV-0003 and INV-0004 are still drafts.

## Still open

- PDF bridge not retested on Android 7 or a phone newer than the A52.
- Home is still the temporary screen. The "coming next" card is outdated. Both go away in M7.
- M7 needs a yes on two packages before coding: `url_launcher` and `archive`.
- Do not merge `m6-payments` into `main` until asked.
