variable "image_family" {
  type    = string
  default = "ubuntu-2204-lts"
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "platform" {
   type          = string
   default       = "standard-v3"
   description   = "Example to validate VM platform."
   validation {
     # проверка вводимых данных пользователем
     # если строка не совпадает со значением из списка, то terraform выдаст ошибку
     condition = contains(["standard-v1", "standard-v2", "standard-v3"], var.platform)
     error_message = "Invalid platform provided."
   }
}

variable "description" {
  type = string
  default = "TODO: description;"
}

variable "boot_disk_type" {
  type    = string
  default = "network-hdd"
}

variable "public_ip" {
  type    = bool
  default = false
}

variable "preemptible" {
  description = "Прерываемая ВМ"
  type        = bool
  default     = true
}

variable "vm_cores" { default = 2 }
variable "vm_memory" { default = 2 }
variable "vm_core_fraction" { default = 20 }
variable "vm_disk_size" { default = 15 }

variable "env_name" {
  type    = string
  default = null
}

# Переменные, которые обязательно нужно указать в основном файле, где используются модули
variable "subnet_zones" { type = list(string) }
variable "subnet_ids" { type = list(string) }
variable "instance_name" { type = string }

/*
машина получит свободный адрес в подсети
Terraform автоматически поймет, что это строка, раз в default стоят кавычки
*/
variable "known_internal_ip" { default = "" }
variable "metadata" { type = map(string) }

variable "labels" {
  description = "for dynamic block 'labels' "
  type        = map(string)
  default = {}
}