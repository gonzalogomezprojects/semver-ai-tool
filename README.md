<p align="center">
  <img src="src/images/logo-semveraitool-small.png" alt="SemVer AI Tool Logo" width="300">
</p>

# SemVer AI Tool

**English** | [Español](./README.es.md)

**SemVer AI Tool** is a next-generation command-line interface (CLI) tool that automates semantic versioning and professional release notes generation using Artificial Intelligence and Conventional Commits.

---

## 🚀 Features
- **Semantic Versioning Automation**: Detects `feat:`, `fix:`, and `BREAKING CHANGE:` from your last commit to safely bump SemVer.
- **AI-Powered Release Notes**: Understands code diffs via Groq API (LLaMA 3.3) and generates professional markdown release notes.
- **Secure by Default**: Stores API credentials locally in `.semver-ai.json` (auto-ignored by Git) preventing leaks.
- **Multi-language Support**: Generate documentation in English or Spanish.

## 📦 Installation & Usage (Via NPX)

Following the modern "Shadcn" philosophy: **Zero global installations required**.

### 1. Initialize your project
Run the interactive wizard in your project root:

```bash
npx github:gonzalogomezprojects/semver-ai-tool init
```

### 2. Create a Release
After committing your changes, trigger the AI release process:

```bash
npx github:gonzalogomezprojects/semver-ai-tool release
```

## 📚 Technical Documentation
For a deep dive into the inner logic and architecture, see [Technical Architecture](./src/docs/en/technical-architecture.md).

## 👨‍💻 Author
Developed with ❤️ by **Gonzalo S. A. Gómez** on [Sarit Startup](https://saritstartup.com.ar/).  
Connect with me on [LinkedIn](https://www.linkedin.com/in/gonzalogomezprojects/).

## 📄 License
MIT License
