"wazuh" = {
  name               = "wazuh"
  desc               = "Wazuh - ubuntu 22.04 - {{ip_range}}.51"
  cores              = 2
  memory             = 8192
  clone              = "Ubuntu_2204_x64"
  dns                = "{{ip_range}}.1"
  ip                 = "{{ip_range}}.51/24"
  gateway            = "{{ip_range}}.1"
}
