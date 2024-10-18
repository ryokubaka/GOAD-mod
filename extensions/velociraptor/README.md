# VELOCIRAPTOR extension

- Extension Name: velociraptor
- Description: Add velociraptor free server and agent on all the domain computers
- Machine name : {{lab_name}}-VELOCIRAPTOR
- Compatible with labs : *

## prerequisites

On ludus prepare template :
```
ludus templates add -d ubuntu-22.04-x64-server
ludus templates build
```

## Install
```
instance_id> install_extension velociraptor
```


## credits
- d4db33f