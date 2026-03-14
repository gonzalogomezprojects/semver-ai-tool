# Guía de Instalación y Configuración (Vía NPM)

Esta guía explica cómo instalar y configurar la herramienta **SemVerAITool** globalmente en tu equipo utilizando el ecosistema nativo de NPM, diseñado para equipos que utilizan Node.js.

## 1. Requisitos Previos

1.  Tener instalado **Node.js** (v16+) y **NPM**.
2.  Tener acceso de lectura al repositorio Git de tu empresa donde está alojado este código.
3.  Tener una **API Key** de [Groq Cloud](https://console.groq.com/).

---

## 2. Instalación Global

La herramienta se distribuye directamente desde el repositorio privado/público usando NPM sin necesidad de registros externos ni compilar binarios y variables de entorno manualmente.

Abre la terminal de tu computadora y ejecuta el comando de instalación apuntando a este repositorio. 
*(Si tu empresa usa SSH o HTTPS, reemplaza la URL correspondiente)*:

```bash
npm install -g git+ssh://git@github.com:TuOrganizacion/semver-ai-tool.git
```

> **Nota:** Al usar el flag `-g`, NPM creará los ejecutables globalmente en tu computadora. A partir de ahora tendrás acceso al comando `semver-ai` en cualquier lugar de tu sistema.

---

## 3. Configuración de Credenciales de IA (Una Sola Vez)

Para evitar filtrar las API Keys en los archivos `.env` de cada proyecto individual, **SemVerAITool** utiliza un almacenamiento global ultra seguro ubicado en el directorio de tu usuario del sistema operativo (Home).

Debes crear un archivo de credenciales en tu máquina **una sola vez**:

### En Windows
1. Ve a tu carpeta de usuario: `C:\Users\TuNombreDeUsuario`
2. Crea una carpeta llamada `.semver-ai` (Nota: empieza con un punto).
3. Dentro de esa carpeta, crea un archivo llamado `credentials.env`.

### En Mac / Linux / WSL
Abre la terminal de bash y ejecuta:
```bash
mkdir -p ~/.semver-ai
touch ~/.semver-ai/credentials.env
```

### Contenido del archivo `credentials.env`

Abre ese archivo con cualquier editor de texto (VS Code, Notepad, Vim) y pega lo siguiente, agregando tus datos reales:

```env
GROQ_API_KEY="gsk_AquiVaTuClaveSecretaDeGroq"
GROQ_MODEL="llama-3.1-70b-versatile"
GROQ_URL="https://api.groq.com/openai/v1/chat/completions"

AUTHOR_NAME="Gonzalo S. A. Gomez"
```

✅ **¡Listo! Nunca más tendrás que tocar contraseñas.**

---

## 4. Uso en tus Proyectos Diarios

Ve a cualquier carpeta de tu computadora donde estés trabajando en un proyecto Node.js (`package.json`) y sigue estos pasos:

### Paso 4.1: Inicializar
Ejecuta el comando para inicializar la herramienta en ese proyecto (creará el `.semver-ai.json`):
```bash
semver-ai init
```
*(Sigue los pasos y nombra tu proyecto).*

### Paso 4.2: Programa y Guardar Cambios (Commits)
Programa tus tareas normalmente y, cuando termines, usa Conventional Commits:
```bash
git add .
git commit -m "feat(auth): implementar sistema JWT y bloquear endpoints"
```

### Paso 4.3: Liberar versión (IA Magic ✨)
Cuando estés listo para liberar una versión, simplemente ejecuta:
```bash
semver-ai release
```

**¿Qué hará la herramienta?**
1. Leerá tu último commit para saber si debe subir un número `Mayor`, `Menor` o un `Patch`.
2. Actualizará el `package.json` de manera automática vía un `npm version`.
3. Enviará los códigos modificados a la IA con Groq.
4. Escribirá un informe súper detallado de las **Release Notes** en Markdown en tu carpeta local `/docs/releases/`.

¡Eso es todo!
