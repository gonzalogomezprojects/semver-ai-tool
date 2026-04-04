<p align="center">
  <img src="src/images/logo-semveraitool-small.png" alt="SemVer AI Tool Logo" width="400">
</p>

# SemVer AI Tool

**English** | [Español](./README.es.md)

**Automate semantic versioning and generate professional AI-powered release notes in seconds.**

---

SemVer AI Tool is a next-generation command-line interface (CLI) that bridges the gap between raw code changes and professional releases. It uses LLaMA 3.3 (via Groq API) to analyze your git history and explain the "why" and "what" behind your updates.

## How it works
The tool integrates directly into your git workflow. It parses **all commit messages since the latest tag** using Conventional Commits rules to determine the next version bump (`patch`, `minor`, or `major`) and then gathers the cumulative `git diff` to understand functional changes. It automatically creates a new release commit and tag for you.

```bash
# 1. Commit your changes
git commit -m "feat: implement real-time collaboration"

# 2. Run the magic
npx semver-ai release
```

## Install
Initialize your project with a zero-config setup:
```bash
npx semver-ai init
```

## What it does
*   **Automatic Versioning**: Detects `feat:`, `fix:`, and `!:` to safely update your `package.json`.
*   **AI Context Awareness**: Uses Large Language Models to interpret multiple code diffs and generate technical documentation.
*   **Git Persistence**: Automatically handles `git commit` and `git tag` for consistent version tracking.
*   **Security First**: Stores your API credentials locally in `.semver-ai.json` (automatically added to `.gitignore`).
*   **Multi-language Support**: Fully localized to English and Spanish.

## CLI Reference

| Command | Argument | Description |
| :--- | :--- | :--- |
| `init` | - | Launches the interactive wizard to configure API keys and preferences. |
| `release` | `patch`\|`minor`\|`major` | (Optional) Force a specific version bump, bypassing the auto-detection. |

## Documentation
*   **[Usage Guide & Workflow](./docs/en/usage-guide.md)**: Deep dive into the tool integration.
*   **[Technical Architecture](./docs/en/technical-architecture.md)**: Explore the inner logic of the CLI.

## 👨‍💻 Author
Developed with ❤️ by **Gonzalo S. A. Gómez** on [Sarit Startup](https://saritstartup.com.ar/).  
Connect with me on [LinkedIn](https://www.linkedin.com/in/gonzalogomezprojects/).

## Links
*   [LinkedIn Profile](https://www.linkedin.com/in/gonzalogomezprojects/)
*   [GitHub Repository](https://github.com/gonzalogomezprojects/semver-ai-tool)

## License
[MIT](./LICENSE) © Gonzalo Gomez
