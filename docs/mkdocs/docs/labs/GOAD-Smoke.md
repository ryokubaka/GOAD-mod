# GOAD-Smoke

Single-VM Ludus lab used for **fast** GOAD / Ludus integration checks. Provisioning is only `smoke.yml` — a **localhost no-op** (no guest WinRM); Ludus deploy already stands up the range.

`providers/ludus/config.yml` marks the Windows VM as **`domain.role: primary-dc`** so Ludus range deploy runs the DC-tagged clone/configure path (not only “non-DC” VM deploy).

See the lab folder [README](../../../../ad/GOAD-Smoke/README.md) for usage.
