# Создание базы данных
resource "yandex_mdb_mysql_database" "db" {
  cluster_id = var.cluster_id
  name       = var.db_name
}

# Создание пользователя
resource "yandex_mdb_mysql_user" "db_user" {
  cluster_id = var.cluster_id
  name       = var.user_name
  password   = var.user_pass

  permission {
    database_name = var.db_name
    roles         = ["ALL"]
  }

  connection_limits {
    max_questions_per_hour   = 10
    max_updates_per_hour     = 20
    max_connections_per_hour = 30
    max_user_connections     = 40
  }

  global_permissions = ["PROCESS"]

  authentication_plugin = "SHA256_PASSWORD"

  depends_on = [yandex_mdb_mysql_database.db]
}