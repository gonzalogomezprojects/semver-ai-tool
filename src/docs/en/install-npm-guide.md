# Installation and Configuration Guide (Via NPM)

This guide explains how to install and configure the **SemVerAITool** globally on your machine using the native NPM ecosystem, designed for teams using Node.js.

## 1. Prerequisites

1.  Have **Node.js** (v16+) and **NPM** installed.
2.  Have read access to the Git repository of your company where this code is hosted.
3.  Have an **API Key** from [Groq Cloud](https://console.groq.com/).

---

## 2. Global Installation

The tool is distributed directly from the private/public repository using NPM without the need for external registries or manually compiling binaries and environment variables.

Open your computer's terminal and execute the installation command pointing to this repository.
*(If your company uses SSH or HTTPS, replace the corresponding URL)*:

```bash
npm install -g git+ssh://git@github.com:YourOrganization/semver-ai-tool.git
```

> **Note:** By using the `-g` flag, NPM will create the executables globally on your computer. From now on, you will have access to the `semver-ai` command anywhere on your system.

---

## 3. AI Credentials Configuration (One-Time Setup)

To avoid leaking API Keys in the `.env` files of each individual project, **SemVerAITool** uses ultra-secure global storage located in your operating system's user directory (Home).

You must create a credentials file on your machine **only once**:

### On Windows
1. Go to your user folder: `C:\Users\YourUsername`
2. Create a folder named `.semver-ai` (Note: starts with a dot).
3. Inside that folder, create a file named `credentials.env`.

### On Mac / Linux / WSL
Open the bash terminal and execute:
```bash
mkdir -p ~/.semver-ai
touch ~/.semver-ai/credentials.env
```

### Content of the `credentials.env` file

Open that file with any text editor (VS Code, Notepad, Vim) and paste the following, adding your real data:

```env
GROQ_API_KEY="gsk_YourSecretGroqKeyHere"
GROQ_MODEL="llama-3.1-70b-versatile"
GROQ_URL="https://api.groq.com/openai/v1/chat/completions"

AUTHOR_NAME="Gonzalo S. A. Gomez"
```

✅ **Done! You will never have to touch passwords again.**

---

## 4. Usage in your Daily Projects

Go to any folder on your computer where you are working on a Node.js project (`package.json`) and follow these steps:

### Step 4.1: Initialize
Run the command to initialize the tool in that project (it will create the `.semver-ai.json`):
```bash
semver-ai init
```
*(Follow the steps and name your project).*

### Step 4.2: Code and Save Changes (Commits)
Code your tasks normally and, when finished, use Conventional Commits:
```bash
git add .
git commit -m "feat(auth): implement JWT system and block endpoints"
```

### Step 4.3: Release version (AI Magic ✨)
When you are ready to release a version, simply run:
```bash
semver-ai release
```

**What will the tool do?**
1. Read your last commit to know if it should bump a `Major`, `Minor`, or `Patch` number.
2. Update the `package.json` automatically via an `npm version`.
3. Send the modified codes to the AI with Groq.
4. Write a super detailed **Release Notes** report in Markdown in your local `/docs/releases/` folder.

That's it!
