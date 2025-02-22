

# network_policy_provider
# allow_public_load_balancers # Flag for creating new IAM role with a load-balancer.admin access ???
# security_groups_ids_list

module "kube" {
  # source = "git::https://github.com/terraform-yc-modules/terraform-yc-kubernetes.git?ref=1.0.8"
  source = "git::https://github.com/DmitryIll/terraform-yc-kubernetes.git"

  cluster_name         = "kube-prod"
  cluster_version      = "1.28"
  description          = "prod_workload"
  folder_id            = local.folder_id #var.folder_id
  network_id           = yandex_vpc_network.prod_net.id  #module.net.vpc_id
  public_access        = false
  enable_cilium_policy = true
  # master_locations     = [for k, v in module.net.private_subnets : v ][0] # для зонального.
  # master_locations     = [for k, v in module.net.private_subnets : v ]
  master_locations     = [
    {
      "subnet_id"      = yandex_vpc_subnet.private_a.id,
      "zone"           = yandex_vpc_subnet.private_a.zone
    },
    {
      "subnet_id"      = yandex_vpc_subnet.private_b.id,
      "zone"           = yandex_vpc_subnet.private_b.zone
    },
    {
      "subnet_id"      = yandex_vpc_subnet.private_d.id,
      "zone"           = yandex_vpc_subnet.private_d.zone
    }

  ]
  #  тут менял:
  use_existing_sa      = true
  master_service_account_id = yandex_iam_service_account.sa_tf.id 
  node_service_account_id =  yandex_iam_service_account.sa_tf.id

  # node_groups_defaults = {
  #   template_name = "{instance_group.id}-{instance.short_id}"
  #   platform_id   = "standard-v3"
  #   node_cores    = 4
  #   node_memory   = 8
  #   node_gpus     = 0
  #   core_fraction = 20
  #   disk_type     = "network-ssd"
  #   disk_size     = 64
  #   preemptible   = true
  #   nat           = false
  #   ipv4          = true
  #   ipv6          = false
  # }
# конец изменениям

  node_groups = {
    "yc-k8s-ng-01" = {
      version     = "1.28"
      description = "demo_workload"
      nat         = false

      fixed_scale = {
        size = 3
      }
    },
    # "yc-k8s-ng-02" = {
    #   version     = "1.28"
    #   description = "demo_workload"
    #   nat         = false
    #   auto_scale = {
    #     min     = 1
    #     max     = 3
    #     initial = 2
    #   }
    # }
  }
}



