# locals {
#   folder_id_workload        = var.cloud_prod_folders[0].id
# }

resource "yandex_resourcemanager_cloud_iam_member" "vpc_admin_prod" {
  cloud_id = module.init.cloud_id #var.cloud_prod_id 
  role     = "vpc.admin"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
}

module "net" {
  # source              = "git::https://github.com/terraform-yc-modules/terraform-yc-vpc.git?ref=1.0.6"
  source              = "git::https://github.com/DmitryIll/terraform-yc-vpc.git"
  labels              = { tag = "prod_net" }
  network_description = "prod_net"
  network_name        = "prod-net"
  create_nat_gw       = true
  folder_id           = local.folder_id # folder_id_workload

  private_subnets = [
    {
      "v4_cidr_blocks" : ["10.121.0.0/16"],
      "zone" : "ru-central1-a",
      "folder_id" : local.folder_id, # folder_id_workload
      "name" : "subnet-ru-central1-a"
    },
    {
      "v4_cidr_blocks" : ["10.131.0.0/16"],
      "zone" : "ru-central1-b",
      "folder_id" : local.folder_id, #folder_id_workload
      "name" : "subnet-ru-central1-b"
    },
    {
      "v4_cidr_blocks" : ["10.141.0.0/16"],
      "zone" : "ru-central1-d",
      "folder_id" : local.folder_id, #folder_id_workload
      "name" : "subnet-ru-central1-d"
    },
  ]
}
