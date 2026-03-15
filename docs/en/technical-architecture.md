# Technical Architecture: SemVerAITool

This document details the software architecture of **SemVerAITool**, structured in a modular, maintainable, and scalable way. All code follows design principles oriented towards Separation of Concerns.

---

## 🌳 Directory Tree

The ecosystem is built in Bash and Node.js as follows:

```text
semver-ai-tool/
├── package.json               # Global NPM package configuration (entrypoint)
├── README.md                  # Main documentation
├── LICENSE                    # MIT project license
└── src/
    ├── cli.sh                 # Entry point / Router
    ├── commands/              # High-level controllers
    │   ├── init.sh            # Initializes local project (.semver-ai.json)
    │   └── release.sh         # Orchestrator of the full release flow
    ├── core/                  # Business Logic Layer and Services
    │   ├── ai_client.sh       # Communication with Groq API / LLM Prompts
    │   ├── config_loader.sh   # Parses local and global variables (credentials.env)
    │   ├── git_manager.sh     # Interacts with Git history and diffs
    │   └── version_manager.sh # SemVer mathematical logic (Major, Minor, Patch)
    └── docs/                  # Folder for internal guides and documentation (Markdown)
```

---

## ⚙️ Modules Description

### 1. The Entry Point (`src/cli.sh`)
It is the **Main Router** of the system.
*   **Function:** When the user types `semver-ai` in their terminal, this file receives the execution, regardless of which project on the computer they are standing in.
*   **Responsibility:** It does not execute business logic. It only parses the passed arguments (e.g., `init`, `release`, `--help`), dynamically calculates in which deep folder of the computer NPM installed the package (to not lose track of its child scripts), and delegates execution to the correct script in the `commands/` folder.

### 2. Controllers (`src/commands/`)
These files act as the "controllers" in a classic MVC architecture. They do not do heavy lifting; they only orchestrate the flow by coordinating the `core` services.

*   **`init.sh`:** Handles the *onboarding*. Asks the user for the project name and generates the `".semver-ai.json"` file locally to save preferences.
*   **`release.sh`:** The most important orchestrator. Executes sequentially:
    1. Calls to load the configuration.
    2. Checks the last commit in Git.
    3. Analyzes if it's a `feat`, `fix`, or a simple chore (to ignore it).
    4. Internally uses NPM (`npm version`) to bump the version in the `package.json`.
    5. Requests the AI to generate Documentation (Llama 3/Groq).
    6. Saves the Release Notes to disk.

### 3. Base Services (`src/core/`)
Here resides the true engine of the tool. Small, testable, and independent functions.

*   **`config_loader.sh`:** Communicates directly with your environment.
    1. Uses native `node -e` commands to read properties from the local `.semver-ai.json` file in a super-secure way (avoiding Bash injections).
    2. Fetches your ultra-secret file: `~/.semver-ai/credentials.env` to temporarily inject the AI Token while running the release.
*   **`git_manager.sh`:** Abstraction layer over Git. Its functions (`get_last_commit_message`, `get_commit_diff`) allow extracting information from the current repository without muddying the main logic. Evaluates text strings to find and parse the _Conventional Commits_ standard.
*   **`version_manager.sh`:** Semantic engine. Receives the response from `git_manager` and does the exact mathematical calculation. *(E.g., if it reads "BREAKING CHANGE", it knows `v1.2.3` must transform into `v2.0.0`)*.
*   **`ai_client.sh`:** The network client (HTTP) to interact with **Groq's** AI.
    * Dynamically constructs the `Prompt` combining the Technical Writer templates along with the pure code of the developer's commit.
    * Uses `Node` environments to assemble and disassemble the JSON request and response object ensuring that if the AI responds with garbage XML (e.g., the `<think>` tag from LLaMA-3.1 models), this module filters everything with regex/sed and returns pristine text in Markdown.

---

## 🔄 Data Flow (Release Lifecycle)

To understand how everything works together in a closed environment, this is the end-to-end flow of `semver-ai release`:

1.  User opens a terminal and types `semver-ai release`.
2.  `cli.sh` wakes up, loads the correct global path, and calls `commands/release.sh`.
3.  `release.sh` imports the services from `/core`.
4.  Tells `config_loader` to inject Groq Cloud environment variables without leaving traces in git.
5.  Asks `git_manager` for the last commit. Let's suppose it answers: `"feat(auth): add JWT login"`.
6.  `release.sh` determines it's a *"minor bump"*. Executes the native node `npm version minor`. The user goes from `1.1.0` to `1.2.0`.
7.  `ai_client.sh` is invoked giving it: the string `"feat(auth)"` + the dump of the code's `git diff`.
8.  Groq Cloud processes the input in `<1s`.
9.  `ai_client.sh` receives Groq's JSON, disassembles the structured `.content` field, and purifies it.
10. `release.sh` receives a beautiful 3-page text in Markdown format, and persists it in `./docs/releases/release_v1.2.0.md`.
