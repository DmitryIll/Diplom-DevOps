

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
  public_access        = true
  security_groups_ids_list = [yandex_vpc_security_group.k8s_public_services.id]

  custom_ingress_rules = {
      "rule1" = {
        protocol = "TCP"
        description = "rule-1"
        v4_cidr_blocks = ["0.0.0.0/0"]
        # from_port = 3000
        from_port = 0
        to_port = 32767
      },
      "rule2" = {
        protocol = "TCP"
        description = "rule-2"
        v4_cidr_blocks = ["0.0.0.0/0"]
        port = 443
      },
      # "rule3" = {
      #   protocol = "TCP"
      #   description = "rule-3"
      #   # predefined_target = "self_security_group"
      #   from_port         = 0
      #   to_port           = 65535
      # }
    }

    custom_egress_rules = {
      "rule1" = {
        protocol       = "ANY"
        description    = "rule-1"
        v4_cidr_blocks = ["0.0.0.0/0"]
        from_port      = 0
        to_port        = 65535
      },
      # "rule2" = {
      #   protocol       = "UDP"
      #   description    = "rule-2"
      #   v4_cidr_blocks = ["10.0.1.0/24"]
      #   from_port      = 8090
      #   to_port        = 8099
      # }
    }


  enable_cilium_policy = true
  # enable_cilium_policy = false
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

  node_groups_defaults = {
    template_name = "{instance_group.id}-{instance.short_id}"
    platform_id   = "standard-v3"
    node_cores    = 2
    node_memory   = 4
    node_gpus     = 0
    core_fraction = 20
    disk_type     = "network-ssd"
    disk_size     = 32
    preemptible   = true
    nat           = false
    ipv4          = true
    ipv6          = false
  }
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


# data "yandex_kubernetes_cluster" "my_cluster" {
#   cluster_id = "some_k8s_cluster_id"
# }

output "kube_cluster_id" {
  value = module.kube.cluster_id
}

