# ADFS lab (GOAD)

This lab defines an Active Directory environment for `ludus.nuketown` with the following Windows hosts:

- `dc01` (`DC01`) – primary domain controller (also used for AD CS / ADFS prerequisites).
- `adfs` (`ADFS`) – ADFS server joined to the domain.
- `entraconnect` (`EntraConnect`) – Entra Connect / AAD Connect server.
- `ws01` (`Workstation`) – Windows 11 workstation.

The `providers/ludus/config.yml` and `providers/ludus/inventory` files are wired for Ludus deployment (using `{{ range_id }}` and `{{ ip_range }}`), and `data/config.json` / `data/inventory` follow the standard GOAD layout for hosts and the `ludus.nuketown` domain. Service accounts `adfs_svc` and `entra_svc` are pre-created in the domain; you can now add your own roles and scenario-specific configuration on top of this base.

