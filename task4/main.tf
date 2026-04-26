# Создание облачной сети
resource "yandex_vpc_network" "cloud" {
  name = var.cloud_name
}

# Создание подсети production
module "vpc_prod" {
  source       = "./vpc"
  env_name     = "production"
  network_id   = yandex_vpc_network.cloud.id
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
    { zone = "ru-central1-b", cidr = "10.0.2.0/24" },
    { zone = "ru-central1-d", cidr = "10.0.3.0/24" },
  ]
}

# Создание подсети develop
module "vpc_dev" {
  source       = "./vpc"
  env_name     = "develop"
  network_id   = yandex_vpc_network.cloud.id
  subnets = [
    { zone = "ru-central1-e", cidr = "10.0.4.0/24" },
  ]
}
