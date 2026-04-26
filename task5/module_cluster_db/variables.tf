variable "cluster_name" { type = string }
variable "network_id" { type = string }
variable "ha" { type = bool }

variable "locations" {
  type = list(object({
    zone      = string
    subnet_id = string
  }))
}