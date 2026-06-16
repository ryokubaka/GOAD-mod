# w11-24h2 extension (Windows 11 24H2 workstation, TPM)

- Extension Name: w11-24h2
- Description: Add a hardened Windows 11 24H2 workstation (virtual TPM) to GOAD, GOAD-Light, or GOAD-Mini in sevenkingdoms.local
- Machine name: {{lab_name}}-W11-24H2
- Ludus template: `win11-24h2-x64-enterprise-tpm-template`
- IP: `{{ip_range}}.34` (vlan 10)
- Compatible labs: GOAD, GOAD-Light, GOAD-Mini

- Lab infos:
  - hostname: catrock
  - Users:
    - Administrators: tywin.lannister, jaime.lannister
    - RDP Users: Lannister group

- Features: run_as_ppl, powershell restricted, ASR (LSASS / PSExec+WMI)

## prerequisites

On Ludus, build the template from [ludus-source-bsl](https://github.com/badsectorlabs/ludus-source-bsl/tree/main/templates):

```
ludus source add https://github.com/badsectorlabs/ludus-source-bsl.git
ludus templates build -n win11-24h2-x64-enterprise-tpm-template
```

## Install

```
instance_id> install_extension w11-24h2
```

## IP deconfliction

Workstation extension IPs (all vlan 10): w11-23h2 `.31`, lx01 `.32`, w11-24h2 `.34`, w11-25h2 `.35` — all can coexist in one range.
