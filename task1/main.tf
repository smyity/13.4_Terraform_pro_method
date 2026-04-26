# облачная сеть
resource "yandex_vpc_network" "develop" {
  name = "develop"
}

# подсеть
resource "yandex_vpc_subnet" "develop_a" {
  name           = "develop-ru-central1-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}

resource "yandex_vpc_subnet" "develop_b" {
  name           = "develop-ru-central1-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.2.0/24"]
}

# ВМы для marketing
module "marketing_vm" {
  source         = "./modules/zagotovka_count"

  env_name       = "marketing"
  subnet_zones   = ["ru-central1-a","ru-central1-b"]
  subnet_ids     = [yandex_vpc_subnet.develop_a.id,yandex_vpc_subnet.develop_b.id]
  public_ip      = true
  instance_name  = "spb"

  labels = { 
    owner= "AAA",
    project = "marketing"
     }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = 1
  }
}

# ВМы для analytics
module "analytics_vm" {
  source         = "./modules/zagotovka_count"

  env_name       = "analytics"
  subnet_zones   = ["ru-central1-a","ru-central1-b"]
  subnet_ids     = [yandex_vpc_subnet.develop_a.id,yandex_vpc_subnet.develop_b.id]
  public_ip      = true
  instance_name  = "msk"

  labels = { 
    owner= "BBB",
    project = "analytics"
     }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = 1
  }
}

data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")
  vars = {
    username       = var.username
    ssh_public_key = var.ssh_public_key
    # превратить список в строку, понятную для YAML
    packages       = jsonencode(var.packages) 
  }
}
