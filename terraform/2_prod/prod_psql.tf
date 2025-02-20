# locals {
#   subnets = { for k, v in module.net.private_subnets : v.zone => v.subnet_id }
# }


# module "pgsql" {
#   source      = "git::https://github.com/terraform-yc-modules/terraform-yc-postgresql.git?ref=1.0.3"
#   network_id  = module.net.vpc_id
#   name        = "one-two-three"
#   description = "demo_workload"
#   folder_id   = var.folder_id
#   access_policy = {
#     web_sql = true
#   }
#   performance_diagnostics = {
#     enabled = true
#   }
#   hosts_definition = [
#     {
#       name             = "one"
#       priority         = 0
#       zone             = "ru-central1-a"
#       assign_public_ip = true
#       subnet_id        = local.subnets["ru-central1-a"]
#     },
#     {
#       name             = "two"
#       priority         = 10
#       zone             = "ru-central1-b"
#       assign_public_ip = true
#       subnet_id        = local.subnets["ru-central1-b"]
#     },
#     {
#       name                    = "three"
#       zone                    = "ru-central1-d"
#       assign_public_ip        = true
#       subnet_id               = local.subnets["ru-central1-d"]
#       replication_source_name = "two"
#     }
#   ]

#   databases = [
#     {
#       name       = "test1"
#       owner      = "test1"
#       lc_collate = "ru_RU.UTF-8"
#       lc_type    = "ru_RU.UTF-8"
#       extensions = ["uuid-ossp", "xml2"]
#     }
#   ]
#   owners = [
#     {
#       name       = "test1"
#       conn_limit = 15
#     }
#   ]

#   users = [
#     {
#       name        = "test1-guest"
#       conn_limit  = 30
#       permissions = ["test1"]
#       settings = {
#         pool_mode                   = "transaction"
#         prepared_statements_pooling = true
#       }
#     }
#   ]
# }