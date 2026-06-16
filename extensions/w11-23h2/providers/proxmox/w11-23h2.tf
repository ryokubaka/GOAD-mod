variable "config_w11_23h2_ext" {
  type = map(object({
    name               = string
    desc               = string
    cores              = number
    memory             = number
    clone              = string
    dns                = string
    ip                 = string
    gateway            = string
  }))

  default = {
    "w11-23h2" = {
       name               = "GOAD-W11-23H2"
       desc               = "W11-23H2 - windows 11 - 192.168.10.31"
       cores              = 2
       memory             = 4096
       clone              = "Windows11_23H2_x64"
       dns                = "192.168.10.1"
       ip                 = "192.168.10.31/24"
       gateway            = "192.168.10.1"
    }
  }
}

locals {
  vm_config = merge(config_w11_23h2_ext, var.vm_config)
}
