resource "yandex_resourcemanager_cloud_iam_member" "vpc_admin_prod" {
  cloud_id = module.init.cloud_id #var.cloud_prod_id 
  role     = "vpc.admin"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "vpc_folder_admin_prod" {
  folder_id = module.init.folders.id[0] 
  role     = "vpc.admin"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
}

resource "yandex_resourcemanager_cloud_iam_member" "vpc_user_prod" {
  cloud_id = module.init.cloud_id #var.cloud_prod_id 
  role     = "vpc.user"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
}

resource "yandex_resourcemanager_cloud_iam_member" "cloud_resource_manager_admin_prod" {
  cloud_id = module.init.cloud_id #var.cloud_prod_id 
  role     = "resource-manager.admin"
  member =  "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
}

resource "yandex_resourcemanager_cloud_iam_member" "cloud_IAM_admin_prod" {
  cloud_id = module.init.cloud_id #var.cloud_prod_id 
  role     = "iam.admin"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
}


resource "yandex_resourcemanager_cloud_iam_member" "vpc_gateways_editor_prod" {
  cloud_id = module.init.cloud_id #var.cloud_prod_id 
  role     = "vpc.gateways.editor"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
}


resource "yandex_resourcemanager_cloud_iam_member" "vpc_privateEndpoints_admin_prod" {
  cloud_id = module.init.cloud_id #var.cloud_prod_id 
  role     = "vpc.privateEndpoints.admin"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
}

resource "yandex_resourcemanager_cloud_iam_member" "vpc_securityGroups_admin_prod" {
  cloud_id = module.init.cloud_id #var.cloud_prod_id 
  role     = "vpc.securityGroups.admin"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
}

resource "yandex_resourcemanager_cloud_iam_member" "vpc_privateAdmin_prod" {
  cloud_id = module.init.cloud_id #var.cloud_prod_id 
  role     = "vpc.privateAdmin"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
}



#---- Создани подсети нужна одна на все ВМ --------------

resource "yandex_vpc_network" "prod_net" {
  name = "prod-net"
}

resource "yandex_vpc_subnet" "public_a" {
  name           = "public-a"
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["10.1.1.0/24"]
  network_id     = "${yandex_vpc_network.prod_net.id}"
}

# resource "yandex_vpc_subnet" "public_b" {
#   name           = "public-b"
#   zone           = "ru-central1-b"
#   v4_cidr_blocks = ["10.1.2.0/24"]
#   network_id     = "${yandex_vpc_network.prod-net.id}"
# }

# resource "yandex_vpc_subnet" "public_d" {
#   name           = "public-d"
#   zone           = "ru-central1-d"
#   v4_cidr_blocks = ["10.1.3.0/24"]
#   network_id     = "${yandex_vpc_network.prod-net.id}"
# }

resource "yandex_vpc_subnet" "private_a" {
  name           = "private-a"
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["10.2.1.0/24"]
  network_id     = "${yandex_vpc_network.prod_net.id}"
  route_table_id = yandex_vpc_route_table.rt_priv.id
}


resource "yandex_vpc_route_table" "rt_priv" {
  name       = "rt-priv"
  network_id = "${yandex_vpc_network.prod_net.id}"

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.nat.network_interface.0.ip_address #yandex_vpc_gateway.nat_gateway.id
  }
}