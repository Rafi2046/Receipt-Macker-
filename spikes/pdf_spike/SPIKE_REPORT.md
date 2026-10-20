# PDF spike (M0, CLAUDE.md §2.1)

Throwaway app. Not part of the product build (excluded from analysis and scripts).
Tested 2026-10-20 on Samsung A52 (SM-A525F, Android 14, WebView 155) and macOS PDFKit (Preview engine).

Test page: Bangla conjuncts (ক্ষ ন্দ্র স্ত্র ঙ্ক জ্ঞ + words), vowel signs, Bangla digits, ৳ amounts,
mixed Bangla/English, a long English paragraph, a 36-row table spanning 2 pages. Fonts: Noto Sans + Noto Sans Bengali (OFL).

| | A · `pdf` 3.13.1 | B · `syncfusion_flutter_pdf` 35.1.41 | C · HTML → PDF via Android WebView |
|---|---|---|---|
| Bangla shaping | **Broken**: conjuncts split with visible hasant, pre-base vowels (ি ে ৈ ো) after the consonant | **Broken**: same as A | **Correct** (Chromium/HarfBuzz) |
| Font fallback (Latin + Bangla in one line) | Yes | No (needed a merged font) | Yes (CSS font stack) |
| Text selectable / extractable | Yes, extracts perfectly (because unshaped) | Yes, perfectly (unshaped) | Yes; English perfect, Bangla copy-paste partly scrambled (normal for shaped Bengali PDFs) |
| Multi-page table, repeated header | Yes | Yes | Yes (`thead`) |
| Output size (this doc) | 33 KB | 116 KB | 54 KB |
| Generation time on A52 | ~0.8 s | ~0.9 s | ~0.9–1.1 s |
| APK size (Dart code delta, arm64 release) | +1.66 MB | +0.83 MB (+0.63 MB merged font) | +0.06 MB |
| License | Apache-2.0 | Commercial or Syncfusion Community License | Our own code; `printing` (Apache-2.0) only for preview/print |

Notes
- `Printing.convertHtml` (printing 5.15.1) is `@Deprecated` and **hangs forever on Android 14** (WebView never attached).
  C uses a ~100-line native bridge instead (`android/app/src/main/kotlin/.../MainActivity.kt` + `android/print/PdfPrintBridge.java`):
  attach an invisible WebView, load the HTML, `createPrintDocumentAdapter`, write to a file.
- `PdfPrintBridge` sits in the `android.print` package to reach package-private callback constructors (same trick `printing` has used for years). It works on Android 14; must be re-tested on the oldest and newest API levels we support.
- C2 (system fonts instead of embedded) also shapes correctly but depends on the device's font; embedding gives a consistent result.
- Neither `pdf` nor Syncfusion contains any Indic shaping code (checked the sources).

Recommendation: **C**.
