# QuickBill branding

Source SVGs (concept A, chosen by the owner). Edit these, then regenerate:

| File | Used for |
|---|---|
| `quickbill_icon.svg` | Full adaptive icon (both layers) on the 108-unit grid, for reference and editing |
| `quickbill_icon_square.svg` | The visible 72 units, full bleed: Play Store icon (`generated/play_store_icon_512.png`) and pre-Android-8 launcher icon |
| `quickbill_icon_foreground.svg` | Adaptive icon foreground, Android 12+ splash icon |
| `quickbill_icon_background.svg` | Adaptive icon background (also set as a color, `#006A4E`) |
| `quickbill_icon_monochrome.svg` | Android 13+ themed icon |
| `quickbill_logo.svg` | In-app logo (`AppImages.logo`) and the pre-Android-12 splash |

Grid: 108 units (Android adaptive icon). Launchers show the middle 72 units;
keep artwork inside the 66-unit safe circle centered at (54, 54).

Regenerate everything with `scripts/branding.sh` (renders the PNGs with
headless Chrome, then runs flutter_launcher_icons and flutter_native_splash).

`concepts/` keeps the three original concepts for reference.
