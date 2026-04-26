variable "subnets" {
  type = list(object({
    zone = string
    cidr = string
  }))
}

variable "env_name" { type = string }
variable "network_id" { type = string }

resource "yandex_vpc_subnet" "vpc_subnet" {
  for_each   = { for index, znachenie in var.subnets : "${znachenie.zone}-${format("%02d", index + 1)}" => znachenie }
  name       = "${var.env_name}-${each.key}"
  network_id = var.network_id
  zone       = each.value.zone
  # в зависимости от того, какая будет выбрана zone подставится значение cidr
  v4_cidr_blocks = [each.value.cidr]
}
