variable "config_ws02_ext" {
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
    "ws02" = {
       name               = "GOAD-ws02"
       desc               = "ws02 - windows 11 - 192.168.10.34"
       cores              = 2
       memory             = 4096
       clone              = "Windows11_24H2_x64"
       dns                = "192.168.10.1"
       ip                 = "192.168.10.34/24"
       gateway            = "192.168.10.1"
    }
  }
}

locals {
  vm_config = merge(config_ws02_ext, var.vm_config)
}
