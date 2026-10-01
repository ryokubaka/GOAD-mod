# securityonion3

- Extension name : `securityonion3`
- Compatibility  : `*`
- Providers : **Ludus only** (other providers are stubs)
- Add a machine  : `so` (`{{ip_range}}.20`, vlan **20**)
- Roles : `extensions/securityonion/vendor/ludus-source-meow` (initialized by `install_extension`)

Adds Security Onion **3.3** standalone to a GOAD lab (same agent/security flow as `securityonion`).

Do **not** enable with `securityonion` (same IP).

## Prerequisites

- Packer template `securityonion-3.3-x64-template` (from [ludus-source-meow](https://github.com/ryokubaka/ludus-source-meow), branch `feat/securityonion-3.3.0` until that template is on `main`)
- **20 GiB** RAM (`ram_min_gb` = `ram_gb`). so-setup needs ≥16 GiB MemTotal, and a 16 GiB VM reports ~15.2 GiB.
- Internet + DNS to `repo.securityonion.net`
- If `inter_vlan_default: DROP`: allow vlan **10→20** TCP `8220,5055,8443` and WG→20 `443`/`22`

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

- SOC: `https://{{ip_range}}.20`
- Web: `onionadmin@ludus.local` / `MeowMeow123`
- Ludus / Ansible SSH: `localuser` / `password` (VM is in the `rhel` group)
- Console: `onion` / `onion`
