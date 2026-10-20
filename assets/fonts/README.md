# Fonts

Both families are SIL Open Font License 1.1 (free for commercial use, embedding allowed, no reserved font name).

| File | Source | Notes |
|---|---|---|
| `NotoSansBengali-*.ttf` | notofonts/bengali `NotoSansBengali-v3.011`, hinted | unmodified |
| `NotoSans-*.ttf` | notofonts/latin-greek-cyrillic `NotoSans-v2.015`, hinted | subset to Latin (U+0000-024F, U+0300-036F, U+1E00-1EFF, punctuation, currency symbols, arrows), all OpenType features kept |

Subset command (fontTools):

```
pyftsubset NotoSans-Regular.ttf --unicodes="U+0000-024F,U+0300-036F,U+1E00-1EFF,U+2000-206F,U+20A0-20CF,U+2100-214F,U+2190-21FF,U+2212" \
  --layout-features='*' --name-IDs='*' --name-languages='*' --notdef-outline --glyph-names
```
