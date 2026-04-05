# 🚀 Guía de Novedades y Flujos de Trabajo (v1.5.0)

Esta documentación detalla las nuevas funcionalidades de **SemVer AI Tool** y cómo integrarlas en diferentes entornos de trabajo.

---

## 🌟 ¿Qué hay de nuevo en la v1.5.0?

### 1. Detección Inteligente de Breaking Changes
Hemos eliminado la dependencia del carácter `!` en el asunto del commit (que solía causar errores en terminales Bash).
- **Nuevo Estándar:** Para disparar una versión **Major**, simplemente incluye la frase `BREAKING CHANGE:` o `BREAKING-CHANGE:` en cualquier parte del cuerpo de tu mensaje de commit.
- **Análisis Completo:** La herramienta ahora lee el mensaje **entero** (asunto + cuerpo), no solo la primera línea.

### 2. CLI Totalmente Interactivo
El comando `release` ahora es una experiencia guiada:
- **Elección de Docs:** Puedes decidir en cada release si quieres generar las notas de IA o saltar este paso (muy útil si solo quieres cambiar la versión rápido).
- **Auto-Push:** Al finalizar, se te preguntará si quieres subir los cambios y tags al repositorio remoto (`git push --follow-tags`) automáticamente. Antes era manual.

### 3. Ayuda Bilingüe Integrada
El comando `help` ha sido completamente rediseñado:
- **Detección de idioma automática:** El CLI detecta si tu proyecto usa inglés o español y muestra la ayuda correspondiente.
- **Manual de Bolsillo:** Incluye guías rápidas sobre SemVer y tips para evitar errores en terminales Bash/Zsh.

### 📍 Comando Oficial: semver-ai
Hemos simplificado el nombre del comando para que sea más corto y rápido de escribir. Aunque el paquete se llama `semver-ai-tool` en el repositorio, el comando que debes ejecutar en tu terminal es siempre:
- **`npx semver-ai <comando>`**
- O simplemente **`semver-ai <comando>`** si lo instalaste de forma global.

### 🔄 Mantenimiento y Versión
- **Ver versión:** Usa `semver-ai --version` o `semver-ai -v`.
- **Actualizar:** Usa el nuevo comando **`semver-ai update`** para ver las instrucciones de actualización a la última versión disponible.

---

## 👤 Flujo para un Solo Desarrollador (Solo Dev)

Si trabajas solo, el objetivo es mantener un historial limpio y profesional sin esfuerzo extra.

1.  **Desarrolla**: Haz commits normales siguiendo el estándar. No te preocupes por la versión en cada commit.
    ```bash
    git commit -m "feat: login con Google"
    git commit -m "fix: error en validación de email"
    ```
2.  **Lanza Release**: Cuando termines una sesión de trabajo o una funcionalidad:
    ```bash
    semver-ai release
    ```
3.  **Sigue las instrucciones**: 
    - Responde `Y` para generar la documentación de IA.
    - Responde `y` para subir todo a GitHub al instante.
    
**Beneficio:** Tendrás un repositorio con versiones claras y documentación profesional sin haber escrito ni una nota de release manual.

---

## 👥 Flujo para un Equipo de Desarrollo (Development Team)

En un equipo, la herramienta ayuda a unificar el criterio de versiones y a evitar errores humanos.

### 1. Commits de los Desarrolladores
Cada miembro del equipo hace sus commits normales. Es vital usar `BREAKING CHANGE:` en el cuerpo si el cambio rompe la API.
```bash
# Ejemplo de commit de un desarrollador
git commit -m "feat(api): nuevo endpoint de usuarios" -m "BREAKING CHANGE: la ruta /api/old ya no existe"
```

### 2. El Proceso de Integración (Merge/Pull Request)
Los desarrolladores suben sus ramas. Todavía **no ejecutan el release**. El release se hace sobre la rama principal integrada.

### 3. El Rol del "Release Manager" (o Lead Dev)
Una vez que los PRs están integrados en la rama principal (`main`/`master`):
1. El encargado sincroniza su rama local: `git pull origin main`.
2. Ejecuta `semver-ai release`.
3. La herramienta sumará **todos los commits de todos los desarrolladores** desde el último tag.
4. Genera una única nota de release consolidada que resume el trabajo de todo el equipo.
5. Sube la versión y el tag oficial para que todos los demás lo vean.

**Beneficio:** Un solo punto de verdad para las versiones. Evita que cada desarrollador cree versiones "parche" inconsistentes por su cuenta.

---

## 💡 Resumen de Comandos Rápidos

| Situación | Comando / Acción |
| :--- | :--- |
| **Hacer un cambio importante** | `git commit -m "..." -m "BREAKING CHANGE: mensaje"` |
| **Cerrar una versión** | `semver-ai release` |
| **Subir a Producción** | Responder `y` al prompt de "push" en el release. |

---
*Documentación generada para SemVer AI Tool - Impulsando el versionado inteligente.*
