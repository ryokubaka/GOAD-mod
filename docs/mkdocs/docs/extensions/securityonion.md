# securityonion

- Extension name : `securityonion`
- Compatibility  : `*`
- Providers : **Ludus only** (other providers are stubs)
- Add a machine  : `so` (`{{ip_range}}.20`, vlan **20**)

Adds Security Onion **2.4** standalone to a GOAD lab:

- Sniff `net1` on vlan tag **10** (AD traffic)
- `so-setup iso standalone-net`
- Elastic trial + Defend + prepackaged detection rules
- Sysmon, then Elastic Agent (Fleet) on all `domain` Windows hosts

Ansible roles come from the `extensions/securityonion/vendor/ludus-source-meow` submodule. `install_extension` runs `git submodule update --init` when that checkout is missing.

Do **not** enable with `securityonion3` (same IP).

## Prerequisites

- Packer template `securityonion-2.4-x64-template` (from [ludus-source-meow](https://github.com/ryokubaka/ludus-source-meow))
- Internet + DNS to `repo.securityonion.net` on the SO VM
- If `inter_vlan_default: DROP`: allow vlan **10→20** TCP `8220,5055,8443` and WG→20 `443`/`22`
- **20 GiB** RAM. so-setup needs ≥16 GiB MemTotal, and a 16 GiB VM reports ~15.2 GiB.

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
- Ludus / Ansible SSH: `localuser` / `password` (VM is in the `rhel` group)
- Console: `onion` / `onion`
