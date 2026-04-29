terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  service_account_key_file = file("~/.authorized_key.json")
}

resource "yandex_storage_bucket" "bucket_temp" {
  bucket     = "chumbucket001" # уникальное во всем облаке
  access_key = var.access_key
  secret_key = var.secret_key

  # Дополнительные настройки (опционально)
  max_size   = 1073741824 # лимит размера в байтах (1Gib --> 2^30)
  
  # Настройка класса хранилища: STANDARD, COLD или ICE
  default_storage_class = "STANDARD"

  anonymous_access_flags {
    read = false
    list = false
  }
}
