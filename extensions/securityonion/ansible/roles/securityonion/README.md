# securityonion (GOAD-mod)

Attach sniff `net1` via Proxmox API, wait for guest NIC, run Security Onion
`so-setup iso standalone-net`. Used by GOAD-mod extensions `securityonion` and
`securityonion3`.

Ported from ludus-source-meow `ludus_securityonion`.

See extension `README.md` for enable steps and prerequisites.

SSH for Ludus and this role is `localuser` / `password`. Before `so-setup`, the role links `/root/SecurityOnion` into that home so Salt states install. When guest RAM is under 16 GiB, the role stops and starts the VM on Proxmox so QEMU picks up the new memory cap.
