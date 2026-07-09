# ws01 extension (legacy shim → w11-23h2)

Backward-compatible extension name for instances that still list `ws01`.
Same Ludus template, IP (`.31`), and AD host as `w11-23h2`.

- **Preferred name for new installs:** `w11-23h2`
- **Ludus template:** `win11-23h2-x64-enterprise-template`
- **AD hostname:** casterlyrock
- **IP:** `{{ip_range}}.31`

```
install_extension ws01
# or
install_extension w11-23h2
```

Do not enable both on the same instance (same IP).
