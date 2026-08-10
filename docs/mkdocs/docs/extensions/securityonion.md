# securityonion

- Extension name : `securityonion`
- Compatibility  : `*`
- Providers : **Ludus only** (other providers are stubs)
- Add a machine  : `so` (`{{ip_range}}.20`, vlan **20**)

Adds Security Onion **2.4** standalone to a GOAD lab:

- Sniff `net1` on vlan tag **10** (AD traffic)
- `so-setup iso standalone-net`
- Elastic trial + Defend + prepackaged detection rules
- Elastic Agent (Fleet) on all `domain` Windows hosts

Do **not** enable with `securityonion3` (same IP).

## Prerequisites

- Packer template `securityonion-2.4-x64-template` (from [ludus-source-meow](https://github.com/ryokubaka/ludus-source-meow))
- Internet + DNS to `repo.securityonion.net` on the SO VM
- If `inter_vlan_default: DROP`: allow vlan **10→20** TCP `8220,5055,8443` and WG→20 `443`/`22`
- ≥16 GiB MemTotal for so-setup (provider typically **20 GiB** RAM)

## Install

```text
load <instance_id>
install_extension securityonion
```

Or:

```bash
./goad.sh -t install -l GOAD -p ludus -e securityonion
```

## Access

- SOC: `https://{{ip_range}}.20`
- Web: `onionadmin@ludus.local` / `MeowMeow123`
- SSH: `onion` / `onion`
