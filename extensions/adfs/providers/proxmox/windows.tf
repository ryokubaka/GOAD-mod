"adfs-adfs" = {
  name               = "ADFS-ADFS"
  desc               = "ADFS server - windows server 2022 - {{ip_range}}.70"
  cores              = 4
  memory             = 8192
  clone              = "WinServer2022_x64"
  dns                = "{{ip_range}}.1"
  ip                 = "{{ip_range}}.70/24"
  gateway            = "{{ip_range}}.1"
}
"adfs-entraconnect" = {
  name               = "ADFS-EntraConnect"
  desc               = "Entra Connect - windows server 2022 - {{ip_range}}.71"
  cores              = 4
  memory             = 8192
  clone              = "WinServer2022_x64"
  dns                = "{{ip_range}}.1"
  ip                 = "{{ip_range}}.71/24"
  gateway            = "{{ip_range}}.1"
}
"adfs-ws01" = {
  name               = "ADFS-Workstation"
  desc               = "ADFS workstation - windows 11 - {{ip_range}}.72"
  cores              = 4
  memory             = 4096
  clone              = "Windows11_23H2_x64"
  dns                = "{{ip_range}}.1"
  ip                 = "{{ip_range}}.72/24"
  gateway            = "{{ip_range}}.1"
}
