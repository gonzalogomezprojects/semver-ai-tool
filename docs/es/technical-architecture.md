# Arquitectura Técnica: SemVerAITool

Este documento detalla la arquitectura de software de **SemVerAITool**, estructurada de forma modular, mantenible y escalable. Todo el código sigue principios de diseño orientados a la separación de responsabilidades (Separation of Concerns).

---

## 🌳 Árbol de Directorios

El ecosistema está construido en Bash y Node.js de la siguiente manera:

```text
semver-ai-tool/
├── package.json               # Configuración del paquete global NPM (entrypoint)
├── README.md                  # Documentación principal
├── LICENSE                    # Licencia MIT del proyecto
└── src/
    ├── cli.sh                 # Punto de entrada / Enrutador
    ├── commands/              # Controladores de alto nivel
    │   ├── init.sh            # Inicializa el proyecto local (.semver-ai.json)
    │   └── release.sh         # Orquestador del flujo de release completo
    ├── core/                  # Capa de Lógica de Negocio y Servicios
    │   ├── ai_client.sh       # Comunicación con API de Groq / Prompts de LLM
    │   ├── config_loader.sh   # Parsea variables locales y globales (credentials.env)
    │   ├── git_manager.sh     # Interactúa con el historial y diffs de Git
    │   └── version_manager.sh # Lógica matemática de SemVer (Major, Minor, Patch)
    └── docs/                  # Carpeta de guías y documentación interna (Markdown)
```

---

## ⚙️ Descripción de Módulos

### 1. El Entry Point (`src/cli.sh`)
Es el **Router Principal** del sistema.
*   **Función:** Cuando el usuario teclea `semver-ai` en su terminal, este archivo es el que recibe la ejecución, sin importar en qué proyecto de la computadora esté parado.
*   **Responsabilidad:** No ejecuta lógica de negocio. Solo parsea los argumentos pasados (ej. `init`, `release`, `--help`), calcula de forma dinámica en qué carpeta profunda de la computadora instaló NPM el paquete (para no perder el rastro de sus scripts hijos) y delega la ejecución al script correcto en la carpeta `commands/`.

### 2. Controladores (`src/commands/`)
Estos archivos actúan como los "controladores" en una arquitectura MVC clásica. No hacen trabajo pesado, solo orquestan el flujo coordinando a los servicios de `core`.

*   **`init.sh`:** Se encarga de hacer el *onboarding*. Pregunta al usuario el nombre del proyecto y genera el archivo `".semver-ai.json"` localmente para guardar preferencias.
*   **`release.sh`:** El orquestador más importante. Ejecuta secuencialmente:
    1. Llama a cargar la configuración.
    2. Comprueba el último commit en Git.
    3. Analiza si es `feat`, `fix` o un simple chore (para ignorarlo).
    4. Utiliza a NPM internamente (`npm version`) para aumentar la versión en el `package.json`.
    5. Solicita a AI la generación de Documentación (Llama 3/Groq).
    6. Guarda las Release Notes en disco.

### 3. Servicios Base (`src/core/`)
Aquí reside el verdadero motor de la herramienta. Funciones pequeñas, testables e independientes.

*   **`config_loader.sh`:** Se comunica directamente con tu entorno. 
    1. Usa comandos nativos de `node -e` para leer propiedades del archivo local `.semver-ai.json` de manera súper segura (evitando inyecciones en Bash).
    2. Va a buscar tu archivo ultra secreto: `~/.semver-ai/credentials.env` para inyectar temporalmente el Token de la IA mientras corre el release.
*   **`git_manager.sh`:** Capa de abstracción sobre Git. Sus funciones (`get_last_commit_message`, `get_commit_diff`) permiten extraer información del repositorio actual sin ensuciar la lógica principal. Evalúa las cadenas de texto para encontrar y parsear el estándar de _Conventional Commits_.
*   **`version_manager.sh`:** Motor semántico. Recibe la respuesta del `git_manager` y hace el cálculo matemático exacto. *(Ej. Si lee "BREAKING CHANGE", sabe que `v1.2.3` debe transformarse en `v2.0.0`)*.
*   **`ai_client.sh`:** El cliente de red (HTTP) para interactuar con la IA de **Groq**. 
    * Construye dinámicamente el `Prompt` combinando las plantillas de Escritor Técnico junto con el código puro del commit del desarrollador. 
    * Usa entornos de `Node` para armar y desarmar el objeto JSON de request y response asegurando que si la IA responde con XML basura (ej. la etiqueta `<think>` de los modelos LLaMA-3.1), este módulo filtra todo con regex/sed y devuelve texto prístino en Markdown.

---

## 🔄 Flujo de Datos (Lifecycle de Release)

Para entender cómo funciona todo junto en un entorno cerrado, este es el flujo de principio a fin de `semver-ai release`:

1.  Usuario abre terminal y escribe `semver-ai release`.
2.  `cli.sh` se despierta, carga la ruta global correcta y llama a `commands/release.sh`.
3.  `release.sh` importa los servicios de `/core`.
4.  Le dice a `config_loader` que inyecte las variables de entorno de Groq Cloud sin dejar rastros en git.
5.  Le pide a `git_manager` el último commit. Supongamos que responde: `"feat(auth): add JWT login"`.
6.  `release.sh` determina que es un *"minor bump"*. Ejecuta el nativo de node `npm version minor`. El usuario pasa de `1.1.0` a `1.2.0`.
7.  Se invoca a `ai_client.sh` dándole: el string de `"feat(auth)"` + el volcado del `git diff` del código.
8.  Groq Cloud procesa el input en `<1s`.
9.  `ai_client.sh` recibe el JSON de Groq, desarma el campo estructurado `.content`, y lo purifica.
10. `release.sh` recibe un texto hermoso de 3 páginas en formato Markdown, y lo persiste en `./docs/releases/release_v1.2.0.md`.
