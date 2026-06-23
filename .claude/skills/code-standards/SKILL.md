---
name: code-standards
description: The user's mandatory code standards for TypeScript, linting, React, and CSS. Use whenever writing, reviewing, or refactoring TypeScript/JavaScript, React components/hooks, or CSS/responsive styles — apply these rules and flag any existing violations. Covers type assertions (`as`), lint-rule bypasses (eslint/biome/oxfmt disable comments), React Rules of Hooks, and mobile-first `min-width` breakpoints.
metadata:
  tags: code-standards, typescript, eslint, biome, oxfmt, react, hooks, css, responsive, mobile-first
---

## When to use

Apply these standards whenever you write, review, or refactor TypeScript/JavaScript, React, or CSS. They are mandatory — follow them in code you produce, and flag any existing violations you encounter.

## TypeScript

- **No type assertions** (`as Type`) — avoid at all costs. Use proper typing instead.

## Linting

- **No bypasses** — never disable eslint, biome, or oxfmt rules inline or via config comments.

## React

- **Respect Rules of Hooks** — hooks only at top level, not in conditions/loops/nested functions.

## CSS / Responsive Design

- **Only use `min-width` breakpoints** — write responsive styles mobile-first; avoid `max-width` breakpoints.

---

*Keep this file minimal. Add rules as patterns emerge.*
