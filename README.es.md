<p align="center">
  <img src="src/images/logo-semveraitool-small.png" alt="SemVer AI Tool Logo" width="400">
</p>

# SemVer AI Tool

[English](./README.md) | **Español**

**Automatiza el versionado semántico y genera notas de lanzamiento profesionales con IA en segundos.**

---

SemVer AI Tool es una interfaz de línea de comandos (CLI) de próxima generación que cierra la brecha entre los cambios de código y los lanzamientos profesionales. Utiliza LLaMA 3.3 (vía Groq API) para analizar tu historial de git y explicar el "por qué" y el "qué" detrás de tus actualizaciones.

## Cómo funciona
La herramienta se integra directamente en tu flujo de trabajo de git. Analiza **todos los mensajes de commit desde el último tag** utilizando las reglas de Conventional Commits para determinar el siguiente incremento de versión y recopila el `git diff` acumulado. Crea automáticamente un commit de lanzamiento y una etiqueta (tag) por ti.

```bash
# 1. Haz commit de tus cambios
git commit -m "feat: implement real-time collaboration"

# 2. Lanza la magia
npx semver-ai release
```

## Instalación
Inicializa tu proyecto con una configuración zero-config:
```bash
npx semver-ai init
```

## Qué hace
*   **Versionado Automático**: Detecta `feat:`, `fix:`, y `BREAKING CHANGE:` para actualizar de forma segura tu `package.json`.
*   **CLI Interactiva**: Te permite elegir si generar documentación de IA y realizar el `git push --follow-tags` automáticamente.
*   **Conciencia de Contexto con IA**: Utiliza Modelos de Lenguaje Extensos (LLMs) para interpretar múltiples diffs de código y generar documentación técnica.
*   **Persistencia en Git**: Gestiona automáticamente el `git commit`, `git tag` y el `push` opcional.
*   **Seguridad Primero**: Almacena tus credenciales de API localmente en `.semver-ai.json` (agregado automáticamente a `.gitignore`).
*   **Soporte Multilingüe**: Totalmente localizado en Inglés y Español.

## Referencia de la CLI

| Comando | Argumento | Descripción |
| :--- | :--- | :--- |
| `init` | - | Inicia el asistente interactivo para configurar las API keys y preferencias. |
| `release` | `patch`\|`minor`\|`major` | (Opcional) Fuerza un incremento de versión específico, omitiendo la autodetección. |

## Documentación
*   **[Novedades v1.5.0](./docs/es/novedades_v1.5.0.md)**: Lee qué hay de nuevo y cómo usarlo en equipo.
*   **[Guía de Uso y Flujo](./docs/es/guia-uso.md)**: Profundiza en la integración de la herramienta.
*   **[Arquitectura Técnica](./docs/es/technical-architecture.md)**: Explora la lógica interna de la CLI.

## 👨‍💻 Autor
Desarrollado con ❤️ por **Gonzalo S. A. Gómez** en [Sarit Startup](https://saritstartup.com.ar/).  
Conéctate conmigo en [LinkedIn](https://www.linkedin.com/in/gonzalogomezprojects/).

## Enlaces
*   [Perfil de LinkedIn](https://www.linkedin.com/in/gonzalogomezprojects/)
*   [Repositorio de GitHub](https://github.com/gonzalogomezprojects/semver-ai-tool)

## Licencia
[MIT](./LICENSE) © Gonzalo Gomez
