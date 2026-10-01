# Security Onion 3.3 extension

- Extension Name: `securityonion3`
- Description: Add Security Onion 3.3 standalone (Ludus) + Sysmon and Fleet agents on domain hosts
- Machine: `{{range_id}}-so` @ `{{ip_range}}.20` (vlan **20**)
- Compatible with labs: `*`
- **Provider: Ludus only** — other providers are stubs
- Ansible roles: the `extensions/securityonion/vendor/ludus-source-meow` submodule (`.gitmodules` branch, currently `main`). `install_extension` initializes it when the checkout is missing.

Do **not** enable together with `securityonion` (same IP `.20`).

## Prerequisites

1. Build the Packer template from [ludus-source-meow](https://github.com/ryokubaka/ludus-source-meow):

```bash
# securityonion-3.3-x64-template is on ludus-source-meow branch feat/securityonion-3.3.0
ludus templates build -n securityonion-3.3-x64-template
```

2. Ludus range networking (if `inter_vlan_default: DROP`):
   - vlan **10 → 20** TCP `8220`, `5055`, `8443` (Fleet)
   - WireGuard → vlan **20** TCP `443`, `22`

3. **20 GiB** RAM (`ram_min_gb` = `ram_gb`). so-setup needs ≥16 GiB MemTotal, and a 16 GiB VM reports ~15.2 GiB.

## Install

```text
load <instance_id>
install_extension securityonion3
```

Or:

```bash
./goad.sh -t install -l GOAD -p ludus -e securityonion3
```

## Access

- SOC HTTPS: `https://{{ip_range}}.20`
- Web: `onionadmin@ludus.local` / `MeowMeow123`
- Ludus / Ansible SSH: `localuser` / `password` (template account; the VM is in the `rhel` group)
- Setup retries `elasticfleet.install_agent_grid` when Salt cannot sign in to the local master, then continues so-setup.
- Console: `onion` / `onion`

## Uninstall

Not implemented.
