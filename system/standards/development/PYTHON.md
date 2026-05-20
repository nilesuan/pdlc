# PYTHON.md — Python language standard

**Authoritative sources:** [PEP 8](https://peps.python.org/pep-0008/) (verified 2026-04-24, the primary Python style guide); [`../../../handbook/04-build.md`](../../../handbook/04-build.md) "Automate with a formatter / linter / type checker" prescriptions; [`../../../research/04-development/coding-practices.md`](../../../research/04-development/coding-practices.md) §6 (Style guides) and §5 (Static analysis).

## Scope

Applies to every Python service / library / script in this organization. Loaded by the build, test, and review commands when the diff includes `*.py` files (or `pyproject.toml`, `requirements*.txt`, `setup.py`, `setup.cfg`).

## Hard rules

1. **PEP 8 is the style baseline.** PEP 8 is "the style guide for Python code in the standard library" — Authors: van Rossum, Warsaw, Coghlan; created 2001-07-05; latest update on the fetched page 2025-04-04 [VERIFIED via [PEP 8](https://peps.python.org/pep-0008/)]. Deviations from PEP 8 require an ADR.
2. **Format with `black` (or compatible).** From [`../../../handbook/04-build.md`](../../../handbook/04-build.md) §"Automate with a formatter": "`black`, `prettier`, `gofmt`, `rustfmt`. Run on save, in pre-commit, and in CI." Project-wide line length per `black` default (88) unless an ADR documents otherwise.
3. **Lint with `ruff` (preferred) or `flake8`.** From [`../../../handbook/04-build.md`](../../../handbook/04-build.md) §"Automate with a linter": "`ruff`/`flake8`, `eslint`, `golangci-lint`, `clippy`. Fail CI on errors." `ruff` subsumes most flake8 plugins and runs orders of magnitude faster on large codebases.
4. **Type-check with `mypy` or `pyright`.** From [`../../../handbook/04-build.md`](../../../handbook/04-build.md) §"Type checker": "`mypy`/`pyright` for Python ... Strong types catch a class of bugs that would otherwise need tests." CI fails on type errors.
5. **Security-lint with `bandit`.** From [`../../../handbook/04-build.md`](../../../handbook/04-build.md) §"Security-focused linter": "`bandit` (Python), `eslint-plugin-security` (JS), `gosec` (Go). Catch SQL injection patterns, weak crypto, hardcoded secrets." Bandit is also named in [OWASP's Source Code Analysis Tools directory](https://owasp.org/www-community/Source_Code_Analysis_Tools) [VERIFIED via [`../../../research/05-testing/non-functional-testing.md`](../../../research/05-testing/non-functional-testing.md)].
6. **Test with `pytest`.** Per [`../../../handbook/04-build-processes.md`](../../../handbook/04-build-processes.md) §"Language test runner": "pytest, vitest, jest, go test, rspec." `unittest` is acceptable for legacy code being migrated; new code uses `pytest`.

## Tooling stack (minimum)

| Tool | Role | Required on |
|---|---|---|
| `black` | Formatter | pre-commit + CI |
| `ruff` | Linter | pre-commit + CI |
| `mypy` *or* `pyright` | Type checker | CI (pre-commit if fast enough) |
| `bandit` | Security linter | CI |
| `pytest` + `pytest-cov` | Test runner + coverage | CI |
| `gitleaks` *or* `trufflehog` | Secrets scan | pre-commit + CI (per [`../../../handbook/04-build.md`](../../../handbook/04-build.md) §"Secrets scanning") |

Configuration belongs in `pyproject.toml` per [`../../../handbook/04-build-processes.md`](../../../handbook/04-build-processes.md) §"Commit config in-repo": "`.editorconfig`, `pyproject.toml`, `.eslintrc`, `tsconfig.json`, etc."

## Type-hint expectations

- All new public functions / methods / classes have type hints. *Why:* the type checker is the cheapest layer of the test pyramid for Python; static type errors are bugs caught for free.
- Internal helpers may go untyped during a quick spike, but any code surviving to trunk is typed before merge.
- `Any` is permitted at boundaries with untyped third-party code, but should be narrowed to a `TypedDict` / `Protocol` / `dataclass` as soon as the shape is known.

## Project layout (default)

```
service/
  pyproject.toml          # ruff, black, mypy, pytest, project metadata
  src/<package>/          # source (src-layout per Python Packaging Authority)
  tests/                  # pytest discovers here
  .pre-commit-config.yaml # black + ruff + bandit + secrets scan
```

Deviations require an ADR (`docs/adr/`).

## Hard blockers (used by the build / review pipeline)

- **`# noqa` blanket-suppressing an entire file** without an inline justification: blocker.
- **`# type: ignore` without a reason and a tracking issue**: major.
- **`eval`, `exec`, `pickle.loads` on untrusted input**: blocker (CWE-95 / CWE-502 surface).
- **SQL via string concatenation / f-string** on user input: blocker (use parameterized queries / ORM bind params).
- **Hardcoded secret in source**: blocker. (Per the global rule in `CLAUDE.md` §3.)
- **A new dependency without a `pyproject.toml` justification block in PR description**: blocker per [`./TRUNK_BASED.md`](TRUNK_BASED.md) and the build command's hard-rules table.

## Anti-patterns to flag

- Star imports (`from foo import *`) outside `__init__.py` re-export — surfaces in `ruff` as `F403`.
- Mutable default arguments (`def f(x=[]):`) — `ruff` flags as `B006`.
- Bare `except:` clauses — masks all errors including `KeyboardInterrupt` / `SystemExit`.
- Reaching into private names (`module._private`) across module boundaries.
- Catching `Exception` to log-and-continue without a re-raise on truly unexpected types.
- `print` for production logging — use the `logging` module wired to the observability stack per [`../operations/OBSERVABILITY.md`](../operations/OBSERVABILITY.md).

## Versioning

- Library packages follow SemVer per [`../release/VERSIONING.md`](../release/VERSIONING.md).
- Service deployables are versioned by container digest, not Python version string. The Python interpreter pin lives in `pyproject.toml` (`requires-python`) and the deployable Dockerfile.

## Sources

- [PEP 8 — Style Guide for Python Code](https://peps.python.org/pep-0008/) (van Rossum / Warsaw / Coghlan; accessed 2026-04-24) — primary style guide [VERIFIED].
- [Google Python Style Guide](https://google.github.io/styleguide/) (listed on the Google Style Guides index; accessed 2026-04-24) [VERIFIED].
- [`../../../handbook/04-build.md`](../../../handbook/04-build.md) §"Automate with a formatter / linter / type checker / security-focused linter / secrets scanning" — tool prescriptions.
- [`../../../handbook/04-build-processes.md`](../../../handbook/04-build-processes.md) §"Commit config in-repo" — `pyproject.toml` placement.
- [`../../../research/04-development/coding-practices.md`](../../../research/04-development/coding-practices.md) §6 (Style guides — PEP 8 verified primary), §5 (Static analysis — DORA Code Maintainability).
- [`../../../research/05-testing/non-functional-testing.md`](../../../research/05-testing/non-functional-testing.md) §SAST — Bandit listed in OWASP directory [VERIFIED].
- Predecessor: `~/.claude.old/standards/PYTHON.md` (referenced for layout shape; specific tool versions and pin policies were re-grounded against this workspace's handbook + research, not lifted as-is).

## Open questions

- `ruff` adoption rate vs `flake8` is not quantified in this workspace's research; the handbook lists both. The recommendation here favors `ruff` based on the handbook's `ruff/flake8` ordering, not on a measured adoption study.
- Specific minimum versions for `mypy` / `pyright` / `ruff` are not pinned in this standard — they should be pinned in the consuming repo's `pyproject.toml` and refreshed quarterly under the evolve command.
