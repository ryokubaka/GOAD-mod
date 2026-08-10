# Security Onion 2.4 extension

- Extension Name: `securityonion`
- Description: Add Security Onion 2.4 standalone (Ludus) + Fleet agents on domain hosts
- Machine: `{{range_id}}-so` @ `{{ip_range}}.20` (vlan **20**)
- Compatible with labs: `*`
- **Provider: Ludus only** — other providers are stubs

Do **not** enable together with `securityonion3` (same IP `.20`).

## Prerequisites

1. Build the Packer template from [ludus-source-meow](https://github.com/ryokubaka/ludus-source-meow) (or your fork):

```bash
ludus templates add -d securityonion-2.4   # or install from the meow source
ludus templates build -n securityonion-2.4-x64-template
```

2. Ludus range networking (if `inter_vlan_default: DROP`):
   - vlan **10 → 20** TCP `8220`, `5055`, `8443` (Fleet)
   - WireGuard → vlan **20** TCP `443`, `22` (SOC / SSH)

3. SO needs outbound internet + DNS to `repo.securityonion.net` — **stop Testing Mode**
   before install (or allowlist those repos).

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

1. Deploys SO VM (vlan 20, **16–20 GiB** RAM, 8 CPU)
2. Attaches sniff `net1` (vlan tag **10**), runs `so-setup iso standalone-net`
3. Heals `bond0` / containers on redeploy; starts Elastic trial, Defend, detection rules
4. Enrolls Elastic Agent on `domain` Windows hosts → Fleet `endpoints-initial`

## Access

- SOC HTTPS: `https://{{ip_range}}.20`
- Default web user: `onionadmin@ludus.local` / `MeowMeow123` (lab default — change in prod)
- SSH: `onion` / `onion`

## Uninstall

Full extension remove is not implemented. Agent role can uninstall/re-enroll Elastic Agent when the SO manager instance changes.
