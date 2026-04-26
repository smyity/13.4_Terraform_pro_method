# облачная сеть
module "network" {
  source           = "./modules/vpc"

  vpc_network_name = "imperium"
  vpc_subnet_name  = "south_bridge"
  vpc_subnet_zone  = "ru-central1-a"
  vpc_subnet_cidr  = ["10.0.1.0/24"]
}

# ВМы для marketing
module "marketing_vm" {
  source         = "./modules/zagotovka_count"

  env_name       = "marketing"

  # эти переменные ожидают список
  subnet_zones   = [module.network.subnet_zone]
  subnet_ids     = [module.network.subnet_id]
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
  source    = "./modules/zagotovka_count"

  env_name       = "analytics"
  subnet_zones   = [module.network.subnet_zone]
  subnet_ids     = [module.network.subnet_id]
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
