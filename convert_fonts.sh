#!/bin/bash

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 font1.ttf font2.ttf ..."
  exit 1
fi

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

CSSFILE="fonts.css"
> "$CSSFILE"
FAMILIES=()

for FONT in "$@"; do
  BASENAME=$(basename "$FONT" | sed 's/\.[^.]*$//')
  FAMILY=$(echo "$BASENAME" | cut -d'-' -f1)
  WEIGHT=$(get_font_weight "$BASENAME")
  STYLE=$(get_font_style "$BASENAME")

  # Convert to .woff and .woff2
  fontforge -lang=ff -c "Open(\"$FONT\"); Generate(\"${BASENAME}.woff\")"
  woff2_compress "$FONT"

  # Write @font-face block
  cat >> "$CSSFILE" <<EOF
@font-face {
  font-family: '${FAMILY}';
  src: url('${BASENAME}.woff2') format('woff2'),
       url('${BASENAME}.woff') format('woff');
  font-weight: $WEIGHT;
  font-style: $STYLE;
}
EOF

  # Track family name
  if [[ ! " ${FAMILIES[@]} " =~ " ${FAMILY} " ]]; then
    FAMILIES+=("$FAMILY")
  fi
done

# Write .class-name block for each font-family
echo "" >> "$CSSFILE"
for FAM in "${FAMILIES[@]}"; do
  CLASSNAME=$(echo "$FAM" | tr '[:upper:]' '[:lower:]')
  echo ".${CLASSNAME} { font-family: '${FAM}'; }" >> "$CSSFILE"
done

echo "Conversion complete. Generated CSS file: $CSSFILE"
