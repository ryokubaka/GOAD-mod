"ws02" = {
  name               = "ws02"
  desc               = "ws02 - windows 11 - {{ip_range}}.34"
  cores              = 2
  memory             = 4096
  clone              = "Windows11_24H2_x64"
  dns                = "{{ip_range}}.1"
  ip                 = "{{ip_range}}.34/24"
  gateway            = "{{ip_range}}.1"
}
