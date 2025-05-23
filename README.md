# 🧰 Conversor de Fuentes Web

Este script convierte fuentes `.ttf` y `.otf` en `.woff` y `.woff2`, y genera un archivo `fonts.css` listo para usar en la web.

---

## 📁 Estructura del proyecto

Organiza tu carpeta así:
```
project/
├── fonts/ ← aquí van las fuentes originales (.otf, .ttf)
├── webfonts/ ← aquí se generarán .woff, .woff2 y fonts.css
├── convert_fonts.sh
```


## 💻 Requisitos

### En macOS:

```bash
brew install fontforge woff2
```
### En Ubuntu/Debian:
```bash
sudo apt update
sudo apt install fontforge woff2
```
### En Windows (usando WSL - Windows Subsystem for Linux)
1. Abre PowerShell como administrador y ejecuta:
```powershell
wsl --install
```
2. Una vez instalado Ubuntu, abre la terminal de Ubuntu y ejecuta:
```bash
sudo apt update
sudo apt install fontforge woff2
```
3. Coloca tu proyecto en una ruta accesible, por ejemplo:
C:\\Users\\tu_usuario\\Downloads\\project

Y accede desde WSL así:
```bash
cd /mnt/c/Users/tu_usuario/Downloads/project
```


## 🛠️ Cómo usar
1. Da permisos al script:
```bash
chmod +x convert_fonts.sh
```
2. Ejecuta el script desde la raíz del proyecto:
```bash
./convert_fonts.sh fonts/*.ttf fonts/*.otf
```

3. El resultado estará en la carpeta webfonts/:
- Archivos .woff y .woff2
- Archivo fonts.css con reglas @font-face y clases de utilidad


## 🎨 Cómo usar las fuentes en tu CSS
```css
@import url('webfonts/fonts.css');

body {
  font-family: 'Avenir', sans-serif;
}

h1, h2, h3 {
  font-family: 'Juana', serif;
}
```

## 📌 Nota
El script detecta automáticamente el peso (Light, Bold, etc.) y el estilo (Italic) según el nombre del archivo.

