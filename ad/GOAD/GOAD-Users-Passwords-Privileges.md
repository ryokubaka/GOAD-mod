# GOAD Lab — Users, Passwords & Privileges Reference

This page lists all AD users, passwords, groups, and privileges defined in the GOAD lab (from `ad/goad`).

---

## Domains Overview

| Domain | NetBIOS | DC Host | Domain Admin Password |
|--------|---------|---------|------------------------|
| **sevenkingdoms.local** | SEVENKINGDOMS | kingslanding (dc01) | `8dCT-DJjgScp` |
| **north.sevenkingdoms.local** | NORTH | winterfell (dc02) | `NgtI75cKV+Pu` |
| **essos.local** | ESSOS | meereen (dc03) | `Ufe-bVXSx9rk` |

---

## Local Administrator Passwords (per host)

| Host | Role | Local admin password |
|------|------|----------------------|
| kingslanding (dc01) | DC | `8dCT-DJjgScp` |
| winterfell (dc02) | DC | `NgtI75cKV+Pu` |
| castleblack (srv02) | Server | `NgtI75cKV+Pu` |
| meereen (dc03) | DC | `Ufe-bVXSx9rk` |
| braavos (srv03) | Server | `978i2pF43UJ-` |

---

## sevenkingdoms.local

### Users & passwords

| Username | Password | Groups | Notes |
|----------|----------|--------|--------|
| tywin.lannister | powerkingftw135 | Lannister | ACE: ForceChangePassword on jaime.lannister; password in SYSVOL (encrypted) |
| jaime.lannister | cersei | Lannister | ACE: GenericWrite on joffrey.baratheon |
| cersei.lannister | il0vejaime | Lannister, Baratheon, **Domain Admins**, Small Council | Domain Admin SEVENKINGDOMS |
| tyron.lannister | Alc00L&S3x | Lannister | ACE: Self-membership on Small Council; joffrey has WriteDACL on tyron |
| robert.baratheon | iamthekingoftheworld | Baratheon, **Domain Admins**, Small Council, **Protected Users** | Domain Admin SEVENKINGDOMS |
| joffrey.baratheon | 1killerlion | Baratheon, Lannister | ACE: WriteDACL on tyron.lannister |
| renly.baratheon | lorastyrell | Baratheon, Small Council | WriteDACL on Crownlands OU; **sensitive** account |
| stannis.baratheon | Drag0nst0ne | Baratheon, Small Council | ACE: KingsGuard has GenericAll on stannis; stannis has GenericAll on kingslanding$ |
| petyer.baelish | @littlefinger@ | Small Council | |
| lord.varys | _W1sper_$ | Small Council | ACE: GenericAll on Domain Admins + AdminSDHolder |
| maester.pycelle | MaesterOfMaesters | Small Council | |

### Local machine access (sevenkingdoms)

| Host | Local Administrators | Remote Desktop Users |
|------|----------------------|----------------------|
| kingslanding (dc01) | robert.baratheon, cersei.lannister, DragonRider | Small Council, Baratheon |

### ACLs (privileges) — sevenkingdoms.local

| Who | On what | Right |
|-----|---------|--------|
| tywin.lannister | jaime.lannister | ForceChangePassword |
| jaime.lannister | joffrey.baratheon | GenericWrite |
| joffrey.baratheon | tyron.lannister | WriteDACL |
| tyron.lannister | Small Council | Self-membership |
| Small Council | DragonStone | Add member (self) |
| DragonStone | KingsGuard | WriteOwner |
| KingsGuard | stannis.baratheon | GenericAll |
| stannis.baratheon | kingslanding$ | GenericAll |
| AcrossTheNarrowSea | kingslanding$ | GenericAll |
| lord.varys | Domain Admins | GenericAll |
| lord.varys | AdminSDHolder | GenericAll |
| renly.baratheon | OU=Crownlands | WriteDACL |

---

## north.sevenkingdoms.local

### Users & passwords

| Username | Password | Groups | Notes |
|----------|----------|--------|--------|
| arya.stark | Needle | Stark | MSSQL execute as user (dbo master/msdb); pass on “all” share |
| eddard.stark | FightP3aceAndHonor! | Stark, **Domain Admins** | Domain Admin NORTH; NTLM relay bot (Responder) |
| catelyn.stark | robbsansabradonaryarickon | Stark | |
| robb.stark | sexywolfy | Stark | Responder/LLMNR bot; RDP scheduler; creds in dc02 config |
| sansa.stark | 345ertdfg | Stark | Unconstrained delegation; SPN HTTP/eyrie |
| brandon.stark | iseedeadpeople | Stark | ASREP roasting (DoesNotRequirePreAuth) |
| rickon.stark | Winter2022 | Stark | Pass spray WinterYYYY |
| hodor | hodor | Stark | Password spray (user=password) |
| jon.snow | iknownothing | Stark, Night Watch | MSSQL sysadmin; kerberoasting; trusted link to ESSOS; constrained delegation |
| samwell.tarly | Heartsbane | Night Watch | Password in LDAP description; MSSQL execute as login → sa; GPO edit (StarkWallpaper) |
| jeor.mormont | _L0ngCl@w_ | Night Watch, Mormont | Local admin castleblack; password in SYSVOL script |
| sql_svc | YouWillNotKerboroast1ngMeeeeee | (none) | SPNs: MSSQLSvc/castleblack... (kerberoastable) |

### Local machine access (north)

| Host | Local Administrators | Remote Desktop Users |
|------|----------------------|----------------------|
| winterfell (dc02) | eddard.stark, catelyn.stark, robb.stark | Stark |
| castleblack (srv02) | jeor.mormont | Night Watch, Mormont, Stark |

### ACLs (privileges) — north.sevenkingdoms.local

| Who | On what | Right |
|-----|---------|--------|
| ANONYMOUS LOGON | DC=North,... | ReadProperty |
| ANONYMOUS LOGON | DC=North,... | GenericExecute |

### MSSQL (castleblack / srv02)

| Role | Account | Notes |
|------|---------|--------|
| sysadmin | NORTH\jon.snow | |
| execute as login | NORTH\samwell.tarly → sa | |
| execute as login | NORTH\brandon.stark → NORTH\jon.snow | |
| execute as user | NORTH\arya.stark → dbo (master) | |
| execute as user | NORTH\arya.stark → dbo (msdb) | |
| sa password | | Sup1_sa_P@ssw0rd! |
| linked server (BRAAVOS) | NORTH\jon.snow → sa | remote: sa_P@ssw0rd!Ess0s |

### Shares (castleblack)

| Share | Path | Full | Change | Read |
|-------|------|------|--------|------|
| thewall | C:\thewall | NORTH\Stark | NORTH\jon.snow, NORTH\samwell.tarly | Users |

### Other (north)

- **Credentials / autologon**: TERMSRV/castleblack and RDP autologon use north\robb.stark / sexywolfy.
- **SYSVOL**: script.ps1 has jeor.mormont / _L0ngCl@w_; secret.ps1 has encrypted secret (tywin scenario).

---

## essos.local

### Users & passwords

| Username | Password | Groups | Notes |
|----------|----------|--------|--------|
| daenerys.targaryen | BurnThemAll! | Targaryen, **Domain Admins** | Domain Admin ESSOS |
| viserys.targaryen | GoldCrown | Targaryen | ACE: WriteProperty on jorah.mormont; CA manager (ADCS ESC7) |
| khal.drogo | horse | Dothraki | MSSQL admin braavos; GenericAll on viserys, ESC4 template; LAPS reader |
| jorah.mormont | H0nnor! | Targaryen | MSSQL execute as login → sa; trusted link to castleblack; LAPS reader |
| missandei | fr3edom | (none) | ASREP roasting; GenericAll on khal.drogo; GenericWrite on viserys.targaryen |
| drogon | Dracarys | Dragons | gMSA (gmsaDragon) has GenericAll on drogon |
| sql_svc | YouWillNotKerboroast1ngMeeeeee | (none) | SPNs: MSSQLSvc/braavos... (kerberoastable) |

### Local machine access (essos)

| Host | Local Administrators | Remote Desktop Users |
|------|----------------------|----------------------|
| meereen (dc03) | daenerys.targaryen, greatmaster | Targaryen |
| braavos (srv03) | khal.drogo | Dothraki |

### ACLs (privileges) — essos.local

| Who | On what | Right |
|-----|---------|--------|
| khal.drogo | viserys.targaryen | GenericAll |
| Spys | jorah.mormont | GenericAll |
| khal.drogo | CN=ESC4,... (cert template) | GenericAll |
| viserys.targaryen | jorah.mormont | WriteProperty |
| DragonsFriends | braavos$ | GenericWrite |
| missandei | khal.drogo | GenericAll |
| gmsaDragon$ | drogon | GenericAll |
| missandei | viserys.targaryen | GenericWrite |

### MSSQL (braavos / srv03)

| Role | Account | Notes |
|------|---------|--------|
| sysadmin | ESSOS\khal.drogo | |
| execute as login | ESSOS\jorah.mormont → sa | |
| sa password | | sa_P@ssw0rd!Ess0s |
| linked server (castleblack) | ESSOS\khal.drogo → sa | remote: Sup1_sa_P@ssw0rd! |

### LAPS (essos)

- **Path**: OU=Laps,DC=essos,DC=local  
- **Readers**: jorah.mormont, Spys (cross-forest; Spys = Small Council from sevenkingdoms)

### Cross-forest / special groups

- **AcrossTheNarrowSea**: member essos\daenerys.targaryen; ACE GenericAll on kingslanding$ (sevenkingdoms).
- **DragonsFriends**: members sevenkingdoms\tyron.lannister, essos\daenerys.targaryen; ACE GenericWrite on braavos$.
- **Spys**: members sevenkingdoms\Small Council; ACE GenericAll on jorah.mormont; LAPS readers.

---

## Quick reference — Domain Admins

| Domain | Domain Admin accounts |
|--------|------------------------|
| sevenkingdoms.local | cersei.lannister, robert.baratheon |
| north.sevenkingdoms.local | eddard.stark |
| essos.local | daenerys.targaryen |

---

## Quick reference — Service / SQL passwords

| Context | Password |
|---------|----------|
| MSSQL sa (castleblack) | Sup1_sa_P@ssw0rd! |
| MSSQL sa (braavos) | sa_P@ssw0rd!Ess0s |
| sql_svc (both domains) | YouWillNotKerboroast1ngMeeeeee |

---

*Generated from `ad/goad/data/config.json` and `ad/goad/README.md`.*
