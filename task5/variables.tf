variable "cloud_id" {
  type        = string
  default = "b1gc3k00qi2fi08ed282"
}

variable "folder_id" {
  type        = string
  default = "b1gbhs59559ntu7hvlcn"
}

variable "cloud_name" {
  type        = string
  default     = "empire"
  description = "название облака"
}

variable "ha" {
  type    = bool
  default = false
}

variable "mysql_locations" {
  type = list(object({
    zone      = string
    cidr      = string
  }))
  default = [
    { zone = "ru-central1-a", cidr = "10.1.0.0/24" },
    { zone = "ru-central1-b", cidr = "10.2.0.0/24" }
  ]
}

variable "db_name" {
  type        = string
  default     = "test"
  description = "название БД"
}

variable "user_name" {
  type        = string
  default     = "app"
  description = "имя пользователя"
}

variable "user_password" {
  type        = string
  default     = "SuperSecure123"
  description = "сильный пароль пользователя"
}

variable "cluster_name" {
  type        = string
  default     = "example"
  description = "название кластера"
}