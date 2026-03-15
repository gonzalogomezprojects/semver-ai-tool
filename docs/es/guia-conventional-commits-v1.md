# Convención de Commits: Conventional Commits
**Guía oficial del equipo (Next.js)**

Versión: 1.0  
Fecha: 2026-02-13
Autor: Gonzalo S. A. Gomez

---

## 0) Objetivo

Estandarizar los mensajes de commit para:

- Mantener un historial claro y auditable
- Facilitar revisiones (PR/MR) y debugging
- Habilitar VDG de manera profesional
- Alinear al equipo con una convención única

> **Regla:** todo commit debe seguir el formato de Conventional Commits.

---

## 1) 📌 Formato base

```txt
<type>(<scope>): <short summary>
```

Ejemplo:

```bash
feat(auth): add JWT authentication
```

---

## 2) 🧱 Types (obligatorios)

> **Nunca inventes nuevos types.** Usar solo los siguientes:

| Type | Cuándo usarlo |
| --- | --- |
| `feat` | Nueva funcionalidad |
| `fix` | Corrección de bug |
| `refactor` | Refactor sin cambio funcional |
| `chore` | Tareas internas (deps, config, scripts) |
| `docs` | Documentación |
| `test` | Tests |
| `perf` | Mejoras de performance |
| `style` | Formato (no lógica) |
| `build` | Build / tooling |
| `ci` | Pipelines / CI |

---

## 3) 🧭 Scope (muy recomendado)

El `scope` indica **qué parte del sistema tocás**.

### 3.1 Scopes sugeridos para nuestro stack

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

✅ Ejemplo:

```bash
fix(logger): prevent logging for health endpoint
```

> **Regla:** si el cambio toca una feature/dominio, usar el nombre del dominio como scope.

---

## 4) ✍️ Summary (línea corta)

Reglas del summary:

- Escribir en **presente**
- Máximo **72 caracteres**
- **Sin punto final**
- Debe ser **explicativo** (qué cambia), no “vago”

❌ Mal:

```bash
feat: added user auth system
fix: fix things
```

✅ Bien:

```bash
feat(auth): add JWT authentication
fix(users): prevent crash when user has no avatar
```

---

## 5) ✅ Ejemplos reales 

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

## 6) 🧠 Breaking changes (cuando aplique)

Si un cambio rompe compatibilidad:

- Agregar `!` después del scope (o type si no hay scope)
- Describir el breaking change en el cuerpo del commit

```bash
feat(auth)!: change token payload structure

BREAKING CHANGE: token no longer includes user email
```

> El `!` es clave si se usa versionado automático.

---

## 7) 🧪 Commits chicos (regla de oro)

❌ Mal (mezcla muchas intenciones):

```txt
feat: auth, logger, swagger, cors, refactor, fix bug
```

✅ Bien (un commit = una intención):

```bash
feat(auth): add JWT guard
fix(auth): validate token expiration
docs(swagger): add auth examples
```

---

## 8) 🛠️ Opcional (pero PRO): emoji + conventional

Si el equipo lo quiere (opcional), se puede prefijar con emojis:

```txt
✨ feat(auth): add JWT authentication
🐛 fix(logger): ignore health endpoint
♻️ refactor(core): simplify bootstrap
```

> Esto es estético. La convención real sigue siendo `type(scope): summary`.

Estaria bueno ver como implementarlo. :D 

---

## 9) 📋 Checklist para el equipo

Antes de commitear, verificar:

- [ ] Uso `type(scope): summary`
- [ ] El type es válido (no inventado)
- [ ] El scope corresponde al dominio/área real
- [ ] Summary en presente, <= 72 chars, sin punto
- [ ] Un commit = una intención
- [ ] Evitar “wip” en ramas principales (`main`, `dev`)

---

## 10) 🧾 TL;DR (lo que usamos siempre)

```bash
feat(auth): add JWT authentication
fix(logger): ignore /api/v1/health logs
chore(deps): update pino logger
docs(swagger): improve API description
```

---

## 11) Próximo paso (si queremos enforcement)

Si el equipo quiere hacerlo “a prueba de humanos”, se puede agregar:

- `commitlint` (valida formato)
- `husky` (hook pre-commit / commit-msg)
- Plantilla de CONTRIBUTING.md
