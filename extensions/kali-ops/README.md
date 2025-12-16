# KALI-OPS extension

- Extension Name: kali-ops
- Description: Add kali-ops machine for conducting offensive operations
- Machine name : {{lab_name}}-KALI-OPS
- Compatible with labs : *

## prerequisites

On ludus prepare template :
```
ludus templates add -d KaliOps-template
ludus templates build
```

## Install
```
instance_id> install_extension kali-ops
```