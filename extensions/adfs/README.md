# ADFS extension

- Extension Name: adfs
- Description: Add an ADFS / Entra Connect / GitLab SAML environment to the current lab, plus MDE/MDI-ready configuration (Defender lab).
- Machines:
  - `{{lab_name}}-ADFS-DC01` (domain controller with AD CS)
  - `{{lab_name}}-ADFS-ADFS` (ADFS server)
  - `{{lab_name}}-ADFS-EntraConnect` (Entra Connect server)
  - `{{lab_name}}-ADFS-Workstation` (Windows 11 workstation)
  - `{{lab_name}}-ADFS-gitlab` (GitLab server)
- Compatible with labs : GOAD, GOAD-Light, GOAD-Mini

## Prerequisites

On Ludus, prepare the required templates:

```bash
ludus templates add -d win2022-server-x64
ludus templates add -d win11-22h2-x64-enterprise
ludus templates add -d debian-12-x64-server
ludus templates build
```

## Install

```bash
instance_id> install_extension adfs
```

This will:

- Deploy the ADFS domain controller, ADFS server, Entra Connect server, workstation, and GitLab VM.
- Configure AD CS and ADFS on the Windows servers.
- Configure GitLab to use ADFS for SAML authentication.
- **Defender / MDE-MDI:** Prepare all Windows hosts for Microsoft Defender for Endpoint (MDE) and Microsoft Defender for Identity (MDI): audit policy, WEF (DC as collector, others as forwarders), Sysmon, AD CS ESC1–15 lab, AD population (lockout policy, OUs, users, Kerberoastable/ASREPRoastable accounts), SMB shares, MDI GPO on DC, ASR and RSAT on workstation. No extra VMs; same DC and workstation get the additional Ansible roles. Based on [ZephrFish/ludus-defender-lab](https://github.com/ZephrFish/ludus-defender-lab). All environment settings (x-admin-pass, x-domain, x-mde-shared style) live in **`ansible/vars/defender_lab.yml`** (sevenkingdoms.local / GOAD); `domain_admin_password` is overridden at run time from the lab’s domain password when available.

After install, onboard MDE and MDI from [security.microsoft.com](https://security.microsoft.com) (MDE: Endpoints → Onboarding → Windows Server 2022 / Windows 11; MDI: Settings → Identities → Sensors → Add sensor on the DC). Take a snapshot after onboarding if you want to revert without re-onboarding.

## Uninstall

- Not implemented yet.
