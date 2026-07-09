"elk" = {
  name               = "elk"
  desc               = "ELK - ubuntu 22.04 - {{ip_range}}.50"
  cores              = 2
  memory             = 4096
  clone              = "Ubuntu_2204_x64"
  dns                = "{{ip_range}}.1"
  ip                 = "{{ip_range}}.50/24"
  gateway            = "{{ip_range}}.1"
}
