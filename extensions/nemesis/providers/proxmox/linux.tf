"nemesis" = {
  name               = "NEMESIS"
  desc               = "NEMESIS - ubuntu 24.04 - {{ip_range}}.53"
  cores              = 4
  memory             = 12288
  clone              = "Ubuntu_2404_x64"
  dns                = "{{ip_range}}.1"
  ip                 = "{{ip_range}}.53/24"
  gateway            = "{{ip_range}}.1"
}
