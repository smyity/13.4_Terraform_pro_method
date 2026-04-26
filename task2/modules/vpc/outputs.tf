output "vpc_subnet" {
    value = yandex_vpc_subnet.develop_a
}

output "subnet_id" {
    value = yandex_vpc_subnet.develop_a.id
}

output "subnet_zone" {
    value = yandex_vpc_subnet.develop_a.zone
}