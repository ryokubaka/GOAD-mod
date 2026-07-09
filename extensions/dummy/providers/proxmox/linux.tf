"dummy" = {
  name               = "dummy"
  desc               = "dummy GOAD extension"
  cores              = 1
  memory             = 1024
  clone              = "Debian_12_x64"
  dns                = "{{ip_range}}.1"
  ip                 = "{{ip_range}}.169/24"
  gateway            = "{{ip_range}}.1"
}
