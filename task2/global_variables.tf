variable "cloud_id" {
  type        = string
  default = "b1gc3k00qi2fi08ed282"
}

variable "folder_id" {
  type        = string
  default = "b1gbhs59559ntu7hvlcn"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
}

variable "username" { type = string }
variable "ssh_public_key" { type = string }

variable "packages" {
  type    = list(string)
  default = ["nginx", "tree"]
}
