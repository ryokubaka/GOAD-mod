"adfs-gitlab" = {
  name               = "ADFS-gitlab"
  desc               = "GitLab - debian 12 - {{ip_range}}.73"
  cores              = 2
  memory             = 8192
  clone              = "Debian_12_x64"
  dns                = "{{ip_range}}.1"
  ip                 = "{{ip_range}}.73/24"
  gateway            = "{{ip_range}}.1"
}
