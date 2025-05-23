# Font Converter CLI Tool

A simple shell script to convert `.ttf` and `.otf` font files to `.woff` and `.woff2`, and automatically generate a CSS file with proper `@font-face` declarations and ready-to-use utility classes.

## 🔧 Features

- Converts fonts to `.woff` and `.woff2` using FontForge and woff2.
- Supports multiple weights and styles (e.g. Regular, Bold, Italic).
- Detects different font families based on file name.
- Automatically generates `@font-face` CSS rules.
- Includes CSS utility classes like `.roboto`, `.opensans`, etc.

## 🧱 Requirements

Make sure you have the following tools installed:

- [FontForge](https://fontforge.org)
- [woff2](https://github.com/google/woff2)

### On macOS:
```bash
brew install fontforge woff2
```

### On Ubuntu/Debian:
```bash
sudo apt install fontforge woff2
```


## 🧱 Requirements
1. Make the script executable:
```bash
chmod +x convert_fonts.sh
```
2. Run the script with one or more font files:
```bash
./convert_fonts.sh OpenSans-Regular.ttf OpenSans-BoldItalic.ttf Roboto-Light.ttf
```
3. The script will generate:

.woff and .woff2 files

A fonts.css file containing:
```css
@font-face {
  font-family: 'OpenSans';
  src: url('OpenSans-Regular.woff2') format('woff2'),
       url('OpenSans-Regular.woff') format('woff');
  font-weight: 400;
  font-style: normal;
}

.roboto {
  font-family: 'Roboto';
}
```

## 📂 Output

All output files (.woff, .woff2, and fonts.css) are placed in the same directory as the script execution.

##  📄 License
MIT License. Use freely in personal or commercial projects.
