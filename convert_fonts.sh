#!/bin/bash

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 fonts/*.ttf fonts/*.otf"
  exit 1
fi

if ! command -v woff2_compress >/dev/null; then
  echo "Error: woff2_compress not found. Install it first."
  exit 1
fi

OUTPUT_DIR="webfonts"
mkdir -p "$OUTPUT_DIR"

get_font_weight() {
  case "$1" in
    *Thin*) echo "100" ;;
    *ExtraLight*|*UltraLight*) echo "200" ;;
    *Light*) echo "300" ;;
    *Regular*|*Normal*) echo "400" ;;
    *Medium*) echo "500" ;;
    *SemiBold*|*DemiBold*) echo "600" ;;
    *Bold*) echo "700" ;;
    *ExtraBold*|*UltraBold*) echo "800" ;;
    *Black*|*Heavy*) echo "900" ;;
    *) echo "400" ;;
  esac
}

get_font_style() {
  [[ "$1" == *Italic* ]] && echo "italic" || echo "normal"
}

CSSFILE="${OUTPUT_DIR}/fonts.css"
> "$CSSFILE"
FAMILIES=()

for FONT in "$@"; do
  BASENAME=$(basename "$FONT" | sed 's/\\.[^.]*$//')
  FAMILY=$(echo "$BASENAME" | cut -d'-' -f1)
  WEIGHT=$(get_font_weight "$BASENAME")
  STYLE=$(get_font_style "$BASENAME")

  echo "Converting: $BASENAME → .woff + .woff2"

  # Generate .woff in webfonts/
  fontforge -lang=ff -c "Open(\"$FONT\"); Generate(\"${OUTPUT_DIR}/${BASENAME}.woff\")"

  # Handle .otf → .ttf → .woff2
  EXT="${FONT##*.}"
  TMP_TTF="${OUTPUT_DIR}/${BASENAME}-tmp.ttf"

  if [[ "$EXT" == "otf" ]]; then
    fontforge -lang=ff -c "Open(\"$FONT\"); Generate(\"$TMP_TTF\")"
    if [ -f "$TMP_TTF" ]; then
      woff2_compress "$TMP_TTF"
      if [ -f "${TMP_TTF%.ttf}.woff2" ]; then
        mv "${TMP_TTF%.ttf}.woff2" "${OUTPUT_DIR}/${BASENAME}.woff2"
        rm -f "$TMP_TTF"
        echo "✅ ${BASENAME}.woff2 generated."
      else
        echo "❌ Failed to generate .woff2 for $BASENAME"
      fi
    else
      echo "❌ Failed to create temp .ttf from $FONT"
    fi
  else
    woff2_compress "$FONT"
    if [ -f "${FONT%.ttf}.woff2" ]; then
      mv "${FONT%.ttf}.woff2" "${OUTPUT_DIR}/${BASENAME}.woff2"
      echo "✅ ${BASENAME}.woff2 generated."
    else
      echo "❌ Failed to generate .woff2 for $BASENAME"
    fi
  fi

  # Write @font-face rule
  cat >> "$CSSFILE" <<EOF
@font-face {
  font-family: '${FAMILY}';
  src: url('${BASENAME}.woff2') format('woff2'),
       url('${BASENAME}.woff') format('woff');
  font-weight: $WEIGHT;
  font-style: $STYLE;
}
EOF

  if [[ ! " ${FAMILIES[@]} " =~ " ${FAMILY} " ]]; then
    FAMILIES+=("$FAMILY")
  fi
done

# Add utility classes
echo "" >> "$CSSFILE"
for FAM in "${FAMILIES[@]}"; do
  CLASSNAME=$(echo "$FAM" | tr '[:upper:]' '[:lower:]')
  echo ".${CLASSNAME} { font-family: '${FAM}'; }" >> "$CSSFILE"
done

echo "✅ Conversion complete. All files are in: $OUTPUT_DIR/"
