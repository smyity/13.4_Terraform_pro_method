# Создание облачной сети
resource "yandex_vpc_network" "cloud" {
  name = var.cloud_name
}

# Создание подсети(-ей) в зависимости от преременной ha
resource "yandex_vpc_subnet" "dev" {
  # берется столько элементов из списка, сколько нужно согласно ha
  # если var.ha  = true --> count = 2
  # если var.ha  = false --> count = 1
  count          = var.ha ? 2 : 1
  
  name           = "dev-${var.mysql_locations[count.index].zone}"
  zone           = var.mysql_locations[count.index].zone
  v4_cidr_blocks = [var.mysql_locations[count.index].cidr]
  network_id     = yandex_vpc_network.cloud.id
}

# Создание модуля кластеризации (даже для одной зоны доступности)
module "example" {
  source       = "./module_cluster_db"

  ha           = var.ha

  cluster_name = var.cluster_name
  network_id   = yandex_vpc_network.cloud.id

  locations    = [
    for i in range(var.ha ? 2 : 1) : {
      zone      = yandex_vpc_subnet.dev[i].zone
      subnet_id = yandex_vpc_subnet.dev[i].id
    }
  ]
}

# Создание базы данных и пользователя
module "db_and_user" {
  source        = "./module_db_user"

  db_name       = var.db_name
  cluster_id    = module.example.cluster_id
  user_name     = var.user_name
  user_pass     = var.user_password

  depends_on = [module.example]
}
