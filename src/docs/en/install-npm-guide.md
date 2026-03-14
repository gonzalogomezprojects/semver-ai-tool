# Installation and Usage Guide (Via NPX)

This tool is designed in the style of Shadcn/Next.js: **zero global installations**. You can run it at any time from your local terminal.

## 1. Prerequisites

1.  Have **Node.js** and **NPM** installed (includes `npx`).
2.  Have an **API Key** from [Groq Cloud](https://console.groq.com/).

---

## 2. Usage in your Projects (Interactive Flow)

Go to any folder on your computer where you are working on a Node.js project (`package.json`) and follow these steps:

### Step 2.1: Initialize the project
Run the following command directly (without installing anything beforehand):

```bash
npx github:gonzalogomezprojects/semver-ai-tool init
```

The tool will interactively ask for:
1. Your project name.
2. Your name as Author.
3. Your **Groq API Key**.

And that's it! Everything will be stored in a local `.semver-ai.json` file.
**Automatic Security**: The tool will automatically add `.semver-ai.json` to your `.gitignore` so your API Key is never pushed to the repository.

### Step 2.2: Code and Save Changes (Commits)
Code your tasks normally and, when finished, use Conventional Commits:
```bash
git add .
git commit -m "feat(auth): implement JWT system and block endpoints"
```

### Step 2.3: Release version (AI Magic ✨)
When you are ready to release a version, simply run:
```bash
npx github:gonzalogomezprojects/semver-ai-tool release
```

**What will the tool do?**
1. Read your last commit to know if it should bump a `Major`, `Minor`, or `Patch`.
2. Update the `package.json` automatically via an `npm version`.
3. Send the modified codes to the AI with Groq.
4. Write a super detailed **Release Notes** report in Markdown in your local `/docs/releases/` folder.

That's it!
