# Create a new MDB High Availability MySQL Cluster.
resource "yandex_mdb_mysql_cluster" "mysql_db_cluster" {
  name        = var.cluster_name
  environment = "PRESTABLE"
  network_id  = var.network_id
  version     = "8.0"

  resources {
    resource_preset_id = "s2.micro"
    disk_type_id       = "network-ssd"
    disk_size          = 16
  }

  maintenance_window {
    type = "WEEKLY"
    day  = "SAT"
    hour = 12
  }

  dynamic "host" {
    for_each = slice(var.locations, 0, var.ha ? 2 : 1)
    content {
      zone      = host.value.zone
      subnet_id = host.value.subnet_id
    }
  }
}
