# Commits Convention: Conventional Commits
**Official Team Guide (Next.js)**

Version: 1.0  
Date: 2026-02-13
Author: Gonzalo S. A. Gomez

---

## 0) Objective

Standardize commit messages to:

- Maintain a clear and auditable history
- Facilitate reviews (PR/MR) and debugging
- Enable Semantic Versioning (SemVer) professionally
- Align the team with a single convention

> **Rule:** Every commit must follow the Conventional Commits format.

---

## 1) 📌 Base Format

```txt
<type>(<scope>): <short summary>
```

Example:

```bash
feat(auth): add JWT authentication
```

---

## 2) 🧱 Types (Mandatory)

> **Never invent new types.** Use only the following:

| Type | When to use it |
| --- | --- |
| `feat` | New feature |
| `fix` | Bug fix |
| `refactor` | Refactoring without functional changes |
| `chore` | Internal tasks (deps, config, scripts) |
| `docs` | Documentation |
| `test` | Tests |
| `perf` | Performance improvements |
| `style` | Formatting (no logic changes) |
| `build` | Build / tooling |
| `ci` | Pipelines / CI |

---

## 3) 🧭 Scope (Highly Recommended)

The `scope` indicates **which part of the system you are touching**.

### 3.1 Suggested Scopes for our stack

```txt
(auth)
(users)
(tenants)
(prisma)
(database)
(logger)
(config)
(swagger)
(health)
(core)
```

✅ Example:

```bash
fix(logger): prevent logging for health endpoint
```

> **Rule:** If the change touches a feature/domain, use the domain name as the scope.

---

## 4) ✍️ Summary (Short line)

Summary rules:

- Write in the **present tense** (imperative mood)
- Maximum **72 characters**
- **No trailing period**
- Must be **explanatory** (what changes), not “vague”

❌ Bad:

```bash
feat: added user auth system
fix: fix things
```

✅ Good:

```bash
feat(auth): add JWT authentication
fix(users): prevent crash when user has no avatar
```

---

## 5) ✅ Real Examples

### 5.1 Feature

```bash
feat(auth): add JWT access and refresh tokens
```

```bash
feat(tenants): support tenant isolation via tenantId
```

---

### 5.2 Fix

```bash
fix(logger): prevent logging for health endpoint
```

```bash
fix(cors): allow credentials for subdomains
```

---

### 5.3 Refactor

```bash
refactor(core): simplify global prefix configuration
```

---

### 5.4 Chore

```bash
chore(deps): update nestjs to v10.3
```

```bash
chore(config): adjust env validation
```

---

### 5.5 Docs

```bash
docs(swagger): document auth headers and responses
```

---

## 6) 🧠 Breaking changes (When applicable)

If a change breaks backward compatibility:

- Add `!` after the scope (or type if there is no scope)
- Describe the breaking change in the commit body

```bash
feat(auth)!: change token payload structure

BREAKING CHANGE: token no longer includes user email
```

> The `!` is key if automated versioning is used.

---

## 7) 🧪 Small Commits (Golden Rule)

❌ Bad (mixes many intentions):

```txt
feat: auth, logger, swagger, cors, refactor, fix bug
```

✅ Good (one commit = one intention):

```bash
feat(auth): add JWT guard
fix(auth): validate token expiration
docs(swagger): add auth examples
```

---

## 8) 🛠️ Optional (but PRO): Emoji + Conventional

If the team wants (optional), you can prefix with emojis:

```txt
✨ feat(auth): add JWT authentication
🐛 fix(logger): ignore health endpoint
♻️ refactor(core): simplify bootstrap
```

> This is aesthetic. The real convention is still `type(scope): summary`.

It would be nice to see how to implement it. :D

---

## 9) 📋 Checklist for the team

Before committing, verify:

- [ ] Used `type(scope): summary`
- [ ] The type is valid (not invented)
- [ ] The scope corresponds to the real domain/area
- [ ] Summary in present tense, <= 72 chars, no period
- [ ] One commit = one intention
- [ ] Avoid “wip” on main branches (`main`, `dev`)

---

## 10) 🧾 TL;DR (What we always use)

```bash
feat(auth): add JWT authentication
fix(logger): ignore /api/v1/health logs
chore(deps): update pino logger
docs(swagger): improve API description
```

---

## 11) Next step (If we want enforcement)

If the team wants to make it “human-proof”, we can add:

- `commitlint` (validates format)
- `husky` (pre-commit / commit-msg hook)
- CONTRIBUTING.md template

If you want to continue with another point, change the versioning of the file by creating a folder with the filename and start with versioning for example conventional-commits-guide-v1.md, conventional-commits-guide-v2.md
## END
