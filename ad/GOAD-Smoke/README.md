# GOAD-Smoke

**Purpose:** tiny lab for **fast** pipeline checks — one Windows VM in Ludus (same merge shape as GOAD-Mini) and a **no-op** playbook `smoke.yml` (localhost only: no `data.yml`, no WinRM/SSH to guests).

**Not** a training AD environment. No GOAD domain build, no vulns. Extensions still install after Ludus provide if selected.

## Use

```text
set_lab GOAD-Smoke
set_provider ludus
set_provisioning_method local
```

Then create / provide / provision as usual. Provisioning runs only `smoke.yml` — it does **not** touch lab VMs (see `playbooks.yml`).

## Ludus

Uses the same `win2019-server-x64-template` and single-VM `config.yml` pattern as GOAD-Mini. Adjust template name in `providers/ludus/config.yml` if your Ludus catalog differs.

The DC VM entry **must** declare `domain.fqdn` + `domain.role: primary-dc` so Ludus’s range Ansible classifies it for **Deploy DC VMs** / sysprep / DC inventory. Without that block, Ludus only clones it on the non-DC path and later DC-tagged plays show *skipping: no hosts matched*.

If you use **Ludus deploy tags** (e.g. from LUX), include tags needed for that path — at minimum **`vm-deploy`**, **`network`**, **`dcs`**, **`windows`**, **`sysprep`** (and usually **`assign-ip`**, **`dns-rewrites`**) or leave tags empty for a full deploy.

## Credentials

`inventory_disable_vagrant` matches Ludus defaults (`localuser` / `password`) when you **do** run guest Ansible from other labs; GOAD-Smoke’s `smoke.yml` does not connect to guests. `data/config.json` remains a stub for catalog/merge consistency.

## Fast extension ping (`smoke-ci`)

The **`extensions/smoke-ci`** extension adds **no** Ludus VMs and runs a single **localhost-only** Ansible play (`ansible/install.yml`). GOAD still requires **`extensions/smoke-ci/providers/ludus/config.yml`** (Jinja merge); that file is comment-only and renders to **no** extra `ludus:` entries. Use it with LUX or the GOAD REPL to validate **extension catalog merge → `install` → extension playbook** without waiting on a second guest (contrast `extensions/dummy`, which provisions a Debian VM).

**LUX:** deploy **GOAD-Smoke** and select extension **`smoke-ci`** on the wizard (same as any other extension).

**REPL / CLI:** see repo script [`scripts/smoke-repl-echo.sh`](../../scripts/smoke-repl-echo.sh) for a paste-ready `set_lab` / `set_extensions smoke-ci` / `install` sequence (replace `INSTANCE` with your workspace id).

**Time budget:** Ludus still clones the Windows DC from `providers/ludus/config.yml`; GOAD lab + `smoke-ci` extension Ansible stay sub-minute once the VM exists. For the shortest Ludus phase, use the smallest template your server offers and optional deploy tags (see above — omitting required tags can break the DC path).
