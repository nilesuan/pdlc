# TYPESCRIPT.md — TypeScript language standard

**Authoritative sources:** [Google Style Guides](https://google.github.io/styleguide/) (TypeScript and JavaScript style guides published, verified 2026-04-24); [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript) [VERIFIED]; [`../../../handbook/04-build.md`](../../../handbook/04-build.md) "Automate with a formatter / linter / type checker" prescriptions; [`../../../research/04-development/coding-practices.md`](../../../research/04-development/coding-practices.md) §6 (Style guides) and §5 (Static analysis).

## Scope

Applies to every TypeScript service / library / frontend in this organization. Loaded by the build, test, and review commands when the diff includes `*.ts`, `*.tsx`, `*.js`, `*.jsx`, `tsconfig.json`, `package.json`, `package-lock.json`, `pnpm-lock.yaml`, or `yarn.lock`.

## Hard rules

1. **TypeScript, not plain JavaScript, for new code.** Plain `.js` is acceptable in build tooling that runs before TS is compiled, in CommonJS interop shims, or for documented configuration files. Anywhere that ships behavior in a service or library is `.ts` / `.tsx`.
2. **`tsconfig.json` runs in `strict: true` mode.** A new repo without `"strict": true` is a blocker; loosening an existing repo from `strict` is a blocker without an ADR.
3. **Format with Prettier.** From [`../../../handbook/04-build.md`](../../../handbook/04-build.md) §"Automate with a formatter": "`black`, `prettier`, `gofmt`, `rustfmt`. Run on save, in pre-commit, and in CI." Prettier configuration lives in the repo (`.prettierrc` or in `package.json`) — not editor-only.
4. **Lint with ESLint.** From [`../../../handbook/04-build.md`](../../../handbook/04-build.md) §"Automate with a linter": "`ruff`/`flake8`, `eslint`, `golangci-lint`, `clippy`. Fail CI on errors." Use `@typescript-eslint/parser` so rules see types.
5. **Type-check with `tsc` in CI.** From [`../../../handbook/04-build.md`](../../../handbook/04-build.md) §"Type checker": "the TS compiler ... Strong types catch a class of bugs that would otherwise need tests. In typed languages this is the compiler." `tsc --noEmit` is required as a CI step distinct from the bundler — bundlers can ship type-broken code.
6. **Security-lint with `eslint-plugin-security` (or equivalent).** From [`../../../handbook/04-build.md`](../../../handbook/04-build.md) §"Security-focused linter": "`bandit` (Python), `eslint-plugin-security` (JS), `gosec` (Go). Catch SQL injection patterns, weak crypto, hardcoded secrets."
7. **Test with `vitest` or `jest`.** Per [`../../../handbook/04-build-processes.md`](../../../handbook/04-build-processes.md) §"Language test runner": "pytest, vitest, jest, go test, rspec." Frontend SPAs may follow the trophy shape (testing-library) per [`../testing/TEST_STRATEGY.md`](../testing/TEST_STRATEGY.md).
8. **Style baseline = Google TypeScript Style Guide OR Airbnb JavaScript Style Guide.** Both are listed and verified at [Google Style Guides — google.github.io/styleguide](https://google.github.io/styleguide/) and [Airbnb JavaScript Style Guide — github.com/airbnb/javascript](https://github.com/airbnb/javascript). Pick one per repo and stick with it; mixing two style guides in the same codebase is a `CR-STYLE-*` major.

## Tooling stack (minimum)

| Tool | Role | Required on |
|---|---|---|
| `tsc` (TypeScript compiler) | Type checker | CI (`tsc --noEmit`) |
| Prettier | Formatter | pre-commit + CI |
| ESLint + `@typescript-eslint` | Linter | pre-commit + CI |
| `eslint-plugin-security` | Security linter | CI |
| `vitest` *or* `jest` | Test runner | CI |
| `gitleaks` *or* `trufflehog` | Secrets scan | pre-commit + CI (per [`../../../handbook/04-build.md`](../../../handbook/04-build.md) §"Secrets scanning") |

Lockfile is committed (`package-lock.json`, `pnpm-lock.yaml`, or `yarn.lock`). Per [`../../../handbook/04-build-processes.md`](../../../handbook/04-build-processes.md) §"Commit config in-repo": "`.editorconfig`, `pyproject.toml`, `.eslintrc`, `tsconfig.json`, etc."

## tsconfig.json baseline

Required compiler options (deviations require an ADR):

```json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitOverride": true,
    "noFallthroughCasesInSwitch": true,
    "exactOptionalPropertyTypes": true,
    "skipLibCheck": false
  }
}
```

`strict: true` enables `noImplicitAny`, `strictNullChecks`, `strictFunctionTypes`, `strictBindCallApply`, `strictPropertyInitialization`, `noImplicitThis`, and `useUnknownInCatchVariables`. The additional flags above close the gaps `strict` does not cover.

## Type-system expectations

- **Prefer `unknown` over `any`.** `any` opts out of the type system. Use `unknown` and narrow.
- **Prefer discriminated unions over enums.** Enums emit runtime code and have surprising semantics; unions of string literals are more honest.
- **Prefer `interface` for public shapes; `type` for unions / intersections / mapped types.**
- **No `as` casts on user input.** Use `zod`/`io-ts`/`typia`/manual narrowing at the boundary, then trust the typed inside.
- **Use `Readonly<T>` / `as const` for invariant data.** Mutation by accident is a class of bug TypeScript can prevent for free.

## Project layout (default)

```
service/
  package.json
  pnpm-lock.yaml          # or package-lock.json / yarn.lock
  tsconfig.json
  .eslintrc.cjs           # or .eslintrc.json / eslint.config.js
  .prettierrc
  src/                    # source
  tests/                  # if separated; otherwise __tests__ / *.test.ts colocated
  dist/                   # build output (gitignored)
```

## Hard blockers (used by the build / review pipeline)

- **`@ts-ignore` / `@ts-expect-error` without a reason and a tracking issue**: major.
- **`as any` / `as unknown as T` without a justification comment**: major.
- **`eval`, `new Function(...)`, `setTimeout(stringArg, …)` on untrusted input**: blocker (CWE-95 surface).
- **SQL / template strings interpolating user input** without parameter binding: blocker.
- **Disabling `strict` (or any of its sub-flags) in `tsconfig.json` without an ADR**: blocker.
- **Hardcoded secret in source**: blocker. (Per the global rule in `CLAUDE.md` §3.)
- **A new dependency without a `package.json` justification block in PR description**: blocker per [`./TRUNK_BASED.md`](TRUNK_BASED.md) and the build command's hard-rules table.
- **Lockfile uncommitted or out of sync with `package.json`**: blocker.

## Anti-patterns to flag

- "Stringly typed" code — passing string keys around instead of typed enums / unions / record types.
- Reaching for `any` to make a difficult error go away. The type error usually points at a real bug.
- Returning `Promise<any>` from API client wrappers — narrow the return type.
- Catching errors with `catch (e)` and treating `e` as a known shape — under `useUnknownInCatchVariables` (part of `strict`), `e` is `unknown`. Narrow with `instanceof Error` or a type guard.
- Re-exporting everything from a barrel `index.ts` that drags in 200 modules; surfaces in slow IDE response and slow tests.
- Snapshot-testing every component (snapshots are change-detectors, not behavior assertions — see [`../testing/TEST_STRATEGY.md`](../testing/TEST_STRATEGY.md)).
- Using `console.log` for production logging — use the structured logger wired to the observability stack per [`../operations/OBSERVABILITY.md`](../operations/OBSERVABILITY.md).

## Versioning

- Library packages follow SemVer per [`../release/VERSIONING.md`](../release/VERSIONING.md).
- Service deployables are versioned by container digest, not `package.json` version. Node version pin lives in `package.json` (`engines.node`), `.nvmrc`, and the deployable Dockerfile — all three must agree.

## Sources

- [Google Style Guides](https://google.github.io/styleguide/) (TypeScript and JavaScript guides; accessed 2026-04-24) [VERIFIED via [`../../../research/04-development/coding-practices.md`](../../../research/04-development/coding-practices.md) §6].
- [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript) (148k+ stars at fetch time; accessed 2026-04-24) [VERIFIED].
- [`../../../handbook/04-build.md`](../../../handbook/04-build.md) §"Automate with a formatter / linter / type checker / security-focused linter / secrets scanning" — tool prescriptions.
- [`../../../handbook/04-build-processes.md`](../../../handbook/04-build-processes.md) §"Commit config in-repo" — `tsconfig.json` placement.
- [`../../../research/04-development/coding-practices.md`](../../../research/04-development/coding-practices.md) §6 (Style guides), §5 (Static analysis — SonarQube, DORA Code Maintainability).
- Predecessor: `~/.claude.old/standards/TYPESCRIPT.md` (referenced for layout shape; specific tool versions and pin policies were re-grounded against this workspace's handbook + research, not lifted as-is).

## Open questions

- The `tsconfig.json` baseline above includes flags not directly cited in this workspace's research (e.g., `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`). They are recommended by the TypeScript team's own documentation; a future research pass should fetch and cite [TypeScript Compiler Options](https://www.typescriptlang.org/tsconfig) directly. Marked `[UNVERIFIED-CITATION]` until then.
- ESLint flat-config (`eslint.config.js`) vs legacy `.eslintrc` is in transition industry-wide; this standard accepts either but does not yet prescribe one.
- `biome` is an emerging alternative to ESLint+Prettier. Not in this workspace's handbook/research yet, so not recommended here. Re-evaluate next quarter under the evolve command.
