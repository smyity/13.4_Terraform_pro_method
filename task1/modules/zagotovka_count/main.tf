data "yandex_compute_image" "my_image" {
  family = var.image_family
}

resource "yandex_compute_instance" "vm" {
  count = var.instance_count

/*
тернарный оператор (условие).
работает по логике: условие ? значение_если_истина : значение_если_ложь
*/
  name               = var.env_name == null ? "${var.instance_name}-${count.index}" : "${var.env_name}-${var.instance_name}-${count.index}"
  platform_id        = var.platform
  hostname           = var.env_name == null ? "${var.instance_name}-${count.index}" : "${var.env_name}-${var.instance_name}-${count.index}"

/*
element(список, индекс)
это встроенная функция Terraform, которая выбирает элемент из списка по его номеру
функция работает по кругу (циклически). Если всего 3 зоны, а создается 10 машин, функция не выдаст ошибку, а начнет сначала:
Машина №0 → зона "a"
Машина №1 → зона "b"
Машина №2 → зона "c"
Машина №3 → снова зона "a" (и так далее)
В
variable "subnet_zones" {
  type = list(string)
}
ожидается список, например: subnet_zones = ["ru-central1-a", "ru-central1-b", "ru-central1-c"]
*/
  zone               = element(var.subnet_zones, count.index)
  # будет описание к созданным ВМ, что они созданы с помощью terraform
  description        = "${var.description} {{created by terraform}}"
  scheduling_policy {
    preemptible = var.preemptible
  }
  
  resources {
    cores         = var.vm_cores
    memory        = var.vm_memory
    core_fraction = var.vm_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.my_image.image_id
      type     = var.boot_disk_type
      size     = var.vm_disk_size
    }
  }

  network_interface {
    subnet_id  = element(var.subnet_ids, count.index)
    nat        = var.public_ip
    # если переменная пустая, передается значение null, тогда облако само назначит IP
    ip_address = var.known_internal_ip == "" ? null : var.known_internal_ip

  }

  metadata = var.metadata # модуль будет ожидать получения переменной в основном файле

}
