# goad-mod vs upstream Orange GOAD — parity audit

**Policy:** This fork should match [Orange-Cyberdefense/GOAD](https://github.com/Orange-Cyberdefense/GOAD) except (1) **more verbose Ansible / operator logging** where we intentionally added it, and (2) **custom extensions** under `extensions/` and related lab definitions.

## Intentional deltas (allowed)

| Area | Notes |
|------|--------|
| **`extensions/`** | Custom labs (elk, exchange, adfs, …) not in upstream. |
| **`goad/provider/ludus/`** | Ludus v2 provider — **not** in stock GOAD (Vagrant/Terraform providers only). Required for Ludus deployments. |
| **Verbosity** | Extra `Log.*` / Ansible visibility where operators asked for it (audit per-commit if unsure). |

## Ludus adapter (review when touching deploy / status)

| File | Role |
|------|------|
| `goad/provider/ludus/ludus.py` | `install()` = config set + `range deploy` + poll `range status` until `SUCCESS` (or timeout / optional log recap escape). |
| `goad/command/linux.py` | `run_ludus` / `run_ludus_result` — Ludus CLI invocation. |
| `goad/instance.py` | Ludus-specific instance paths (`config.yml`, lab user id truncation). |
| `goad.py` | `install_extension` → `install()` then `provision_extension`. |

## Environment variables (Ludus-only operational knobs)

| Variable | Purpose |
|----------|---------|
| `GOAD_LUDUS_INSTALL_TIMEOUT_SEC` | Max seconds waiting for `rangeState == SUCCESS` (default 21600). |
| `GOAD_LUDUS_DEPLOY_POLL_SEC` | Seconds between status polls (default 30). |
| `GOAD_LUDUS_TRUST_RANGE_LOG_RECAP` | If `1`/`yes`/`true`, when still `DEPLOYING`/`WAITING`, treat successful **last** `PLAY RECAP` in `ludus range logs` as completion (use only if Ludus PB state is known to lag; prefer fixing Ludus). |

## Reconciliation with LUX

Ludus UX can patch PocketBase when Ansible finished but `rangeState` stayed `DEPLOYING` (`goad-ludus-reconcile` in ludus-ux). That is an **operational bridge** — prefer Ludus fixing state transitions; keep GOAD-side escapes documented and opt-in where possible.
