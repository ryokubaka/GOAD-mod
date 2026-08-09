# Security Onion 3.2 extension

- Extension Name: `securityonion3`
- Description: Add Security Onion 3.2 standalone (Ludus) + Fleet agents on domain hosts
- Machine: `{{range_id}}-so` @ `{{ip_range}}.20` (vlan **20**)
- Compatible with labs: `*`
- **Provider: Ludus only** — other providers are stubs
- Ansible roles: shared from `extensions/securityonion/ansible/roles/`

Do **not** enable together with `securityonion` (same IP `.20`).

## Prerequisites

1. Build the Packer template from [ludus-source-meow](https://github.com/ryokubaka/ludus-source-meow):

```bash
ludus templates build -n securityonion-3-x64-template
```

2. Ludus range networking (if `inter_vlan_default: DROP`):
   - vlan **10 → 20** TCP `8220`, `5055`, `8443` (Fleet)
   - WireGuard → vlan **20** TCP `443`, `22`

3. Fixed **24 GB** RAM (so-setup needs ≥16 GiB; no balloon under floor).

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
- Web: `onionadmin@ludus.local` / `0n10nAdm1n!`
- SSH: `onion` / `onion`

## Uninstall

Not implemented.
