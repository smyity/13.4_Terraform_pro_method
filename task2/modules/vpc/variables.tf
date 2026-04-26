variable "vpc_network_name" {
  type    = string
}

variable "vpc_subnet_name" {
  type    = string
}

variable "vpc_subnet_zone" {
  type    = string
  validation {
     condition = contains(["ru-central1-a", "ru-central1-b"], var.vpc_subnet_zone)
     error_message = "Wrong subnet zone."
   }
}

variable "vpc_subnet_cidr" {
  type    = list(string)
  default = ["10.0.1.0/24"]
}