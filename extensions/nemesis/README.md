# Nemesis extension

Deploys an Ubuntu VM with [SpecterOps Nemesis](https://github.com/SpecterOps/Nemesis) via the [brmkit.ludus_nemesis](https://github.com/brmkit/ludus_nemesis) Ludus Ansible role.

## Ludus prerequisite

Install roles on the Ludus host before deploying:

```bash
ludus ansible role add geerlingguy.docker
ludus ansible role add brmkit.ludus_nemesis
```

## Usage

```bash
install_extension nemesis
```

## Access

After deploy, Nemesis is available at `https://<ip_range>.53:7443` (basic auth `n:n` per role defaults).
