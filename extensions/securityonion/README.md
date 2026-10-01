# Security Onion 2.4 extension

- Extension Name: `securityonion`
- Description: Add Security Onion 2.4 standalone (Ludus) + Fleet agents on domain hosts
- Machine: `{{range_id}}-so` @ `{{ip_range}}.20` (vlan **20**)
- Compatible with labs: `*`
- **Provider: Ludus only** — other providers are stubs
- Ansible roles: [ludus-source-meow](https://github.com/ryokubaka/ludus-source-meow) submodule at `vendor/ludus-source-meow` (branch in `.gitmodules`, currently `main`)

Do **not** enable together with `securityonion3` (same IP `.20`).

## Roles

Playbooks use the Ludus role names. There is no copy under this extension.

```text
vendor/ludus-source-meow/ansible/roles/ludus_securityonion
vendor/ludus-source-meow/ansible/roles/ludus_so_elastic_security
vendor/ludus-source-meow/ansible/roles/ludus_so_elastic_agent
vendor/ludus-source-meow/ansible/roles/ludus_sysmon
```

After cloning goad-mod:

```bash
git submodule update --init extensions/securityonion/vendor/ludus-source-meow
```

`install_extension` does this itself when the checkout is missing, so a LUX deploy of `securityonion` or `securityonion3` still finds the roles. `securityonion3` uses the same checkout.

## Prerequisites

1. Build the Packer template from [ludus-source-meow](https://github.com/ryokubaka/ludus-source-meow) (or your fork):

```bash
ludus templates add -d securityonion-2.4   # or install from the meow source
ludus templates build -n securityonion-2.4-x64-template
```

The current image creates `localuser` (password `password`) for Ludus SSH. Rebuild if this template was built before that account existed.

The role retries `elasticfleet.install_agent_grid` when Salt cannot sign in to the local master, then continues so-setup.

2. Ludus range networking (if `inter_vlan_default: DROP`):
   - vlan **10 → 20** TCP `8220`, `5055`, `8443` (Fleet)
   - WireGuard → vlan **20** TCP `443`, `22` (SOC / SSH)
   - The SO host firewall leaves analyst/SOC open (`0.0.0.0/0`). The range router is the access control.

3. SO needs outbound internet + DNS to `repo.securityonion.net` — **stop Testing Mode**
   before install (or allowlist those repos). If `testing:` is set, include
   `block_internet: true` (Ludus requires both keys; never `false` to bypass).

4. Sniff NIC attach uses Proxmox/Ludus API env (`LUDUS_RANGE_NUMBER` / range second octet). GOAD ansible derives the range number from `so`’s `ansible_host`.

## Install

```text
load <instance_id>
install_extension securityonion
```

Or:

```bash
./goad.sh -t install -l GOAD -p ludus -e securityonion
```

## What it does

1. Deploys SO VM (vlan 20, **20 GiB** RAM, 8 CPU)
2. Attaches sniff `net1` (vlan tag **10**), runs `so-setup iso standalone-net`
3. Heals `bond0` / containers on redeploy; starts Elastic trial, Defend, detection rules
4. Installs Sysmon on Windows hosts, then enrolls Elastic Agent on `domain` hosts → Fleet `endpoints-initial`

## Access

- SOC HTTPS: `https://{{ip_range}}.20`
- Default web user: `onionadmin@ludus.local` / `MeowMeow123` (lab default — change in prod)
- Ludus / Ansible SSH: `localuser` / `password` (template account; the VM is in the `rhel` group)
- Console: `onion` / `onion`

## Uninstall

Full extension remove is not implemented. Agent role can uninstall/re-enroll Elastic Agent when the SO manager instance changes.
