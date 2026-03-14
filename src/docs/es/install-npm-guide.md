# Guía de Instalación y Uso (Vía NPX)

Esta herramienta está diseñada al estilo de Shadcn/Next.js: **cero instalaciones globales**. Puedes ejecutarla en cualquier momento desde tu terminal local.

## 1. Requisitos Previos

1.  Tener instalado **Node.js** y **NPM** (viene con `npx`).
2.  Tener una **API Key** de [Groq Cloud](https://console.groq.com/).

---

## 2. Uso en tus Proyectos (Flujo Interactivo)

Ve a cualquier carpeta de tu computadora donde estés trabajando en un proyecto Node.js (`package.json`) y sigue estos pasos:

### Paso 2.1: Inicializar el proyecto
Ejecuta el siguiente comando directamente (sin instalar nada antes):

```bash
npx github:gonzalogomezprojects/semver-ai-tool init
```

La herramienta te pedirá interactivamente:
1. El nombre de tu proyecto.
2. Tu nombre como Autor.
3. Tu **Groq API Key**.

¡Y listo! Todo se guardará en un archivo local `.semver-ai.json`. 
**Seguridad Automática**: La herramienta agregará automáticamente `.semver-ai.json` a tu archivo `.gitignore` para que tu API Key nunca se suba al repositorio.

### Paso 2.2: Programa y Guardar Cambios (Commits)
Programa tus tareas normalmente y, cuando termines, usa Conventional Commits:
```bash
git add .
git commit -m "feat(auth): implement JWT system and block endpoints"
```

### Paso 2.3: Liberar versión (IA Magic ✨)
Cuando estés listo para liberar una versión, simplemente ejecuta:
```bash
npx github:gonzalogomezprojects/semver-ai-tool release
```

**¿Qué hará la herramienta?**
1. Leerá tu último commit para saber si debe subir un número `Mayor`, `Menor` o un `Patch`.
2. Actualizará el `package.json` de manera automática vía un `npm version`.
3. Enviará los códigos modificados a la IA con Groq.
4. Escribirá un informe súper detallado de las **Release Notes** en Markdown en tu carpeta local `/docs/releases/`.

¡Eso es todo!
