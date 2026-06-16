# ws02 extension (legacy shim → w11-24h2)

Backward-compatible extension name for instances that still list `ws02`.
Same Ludus template, IP (`.34`), and AD host as `w11-24h2`.

- **Preferred name for new installs:** `w11-24h2`
- **Ludus template:** `win11-24h2-x64-enterprise-tpm-template`
- **AD hostname:** catrock
- **IP:** `{{ip_range}}.34`

```
install_extension ws02
# or
install_extension w11-24h2
```

Do not enable both on the same instance (same IP).
