# windows_activation

Ansible-only extension: runs [MAS](https://github.com/massgravel/Microsoft-Activation-Scripts) on existing Windows lab VMs (`domain` + extension WinRM hosts). **No extra Ludus VMs** — `providers/ludus/config.yml` is empty.

## Install (no `range deploy`)

From a GOAD instance (after lab **Provide** + **Provision lab**):

```text
install_extension windows_activation
```

GOAD enables the extension, **skips** `ludus range deploy` when `machines` is empty, then runs `provision_extension`.

Or explicitly:

```text
provision_extension windows_activation
```

(requires the extension already listed in `instance.json` / enabled via `install_extension` once.)

## Re-run activation

```text
provision_extension windows_activation
```

Set `windows_activation_force: true` in role defaults or host vars to re-apply even when already licensed.

**Defender:** MAS is often flagged as PUA. The role adds a path exclusion for `C:\Tools\MAS` before download (disable with `windows_activation_defender_exclusion: false` only if you pre-stage the script another way).

**Verify:** Uses `slmgr /xpr` plus WMI grace states (not only `LicenseStatus -eq 1`). Default MAS args are `/Z-Windows /S` on servers and workstations (eval VHDs); workstation fallback tries `/HWID /S`. If activation still fails, ensure the VM can reach the internet (TSforge StaticCID) or override with e.g. `windows_activation_server_args: "/Z-Windows /Z-KMS4k /S"`.
