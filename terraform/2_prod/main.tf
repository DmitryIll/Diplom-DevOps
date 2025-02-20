locals {
  folder_id_prod        = var.cloud_prod_folders[0].id
  prod_bucket_name = "${var.prod_prefix}-${random_string.unique_id_prod.result}"
}

resource "random_string" "unique_id_prod" {
  length  = 4
  upper   = false
  lower   = true
  numeric = true
  special = false
}

# Service account supposed to be used as the main subject to run org-level privileged operations (create cloud etc.)
resource "yandex_iam_service_account" "sa_tf_prod" {
  name        = "sa-tf-prod"
  description = "Service account for Terraform"
  folder_id   = local.folder_id_prod
}


resource "yandex_resourcemanager_cloud_iam_member" "cloud_resource_manager_admin_prod" {
  cloud_id = var.cloud_prod_id
  role     = "resource-manager.admin"
  member =  "serviceAccount:${yandex_iam_service_account.sa_tf_prod.id}"
}

resource "yandex_resourcemanager_cloud_iam_member" "cloud_IAM_admin_prod" {
  cloud_id = var.cloud_prod_id
  role     = "iam.admin"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf_prod.id}"
}

resource "yandex_resourcemanager_cloud_iam_member" "vpc_admin_prod" {
  cloud_id = var.cloud_prod_id
  role     = "vpc.admin"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf_prod.id}"
}

resource "yandex_resourcemanager_cloud_iam_member" "vpc_gateways_editor_prod" {
  cloud_id = var.cloud_prod_id
  role     = "vpc.gateways.editor"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf_prod.id}"
}

# resource "yandex_resourcemanager_folder_iam_member" "vpc_gateways_editor_prod" {
#   folder_id = local.folder_id_prod
#   role     = "vpc.gateways.editor"
#   member = "serviceAccount:${yandex_iam_service_account.sa_tf_prod.id}"
# }

resource "yandex_resourcemanager_cloud_iam_member" "vpc_privateEndpoints_admin_prod" {
  cloud_id = var.cloud_prod_id
  role     = "vpc.privateEndpoints.admin"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf_prod.id}"
}

resource "yandex_resourcemanager_cloud_iam_member" "vpc_securityGroups_admin_prod" {
  cloud_id = var.cloud_prod_id
  role     = "vpc.securityGroups.admin"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf_prod.id}"
}

resource "yandex_resourcemanager_cloud_iam_member" "vpc_privateAdmin_prod" {
  cloud_id = var.cloud_prod_id
  role     = "vpc.privateAdmin"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf_prod.id}"
}



# Create a static access key
resource "yandex_iam_service_account_static_access_key" "sa_tf_static_key_prod" {
  service_account_id = yandex_iam_service_account.sa_tf_prod.id
  description        = "Static access key for bucket ${local.prod_bucket_name} and YDB"
}

# Create an authorized access key for the service account
resource "yandex_iam_service_account_key" "sa_auth_key_prod" {
  service_account_id = yandex_iam_service_account.sa_tf_prod.id
  description        = "Key for service account"
  key_algorithm      = "RSA_2048"
}

# Export the key to a file (.key-prod.json) to create a YC profile later
resource "local_file" "key-prod" {
  content  = <<EOH
  {
    "id": "${yandex_iam_service_account_key.sa_auth_key_prod.id}",
    "service_account_id": "${yandex_iam_service_account.sa_tf_prod.id}",
    "created_at": "${yandex_iam_service_account_key.sa_auth_key_prod.created_at}",
    "key_algorithm": "${yandex_iam_service_account_key.sa_auth_key_prod.key_algorithm}",
    "public_key": ${jsonencode(yandex_iam_service_account_key.sa_auth_key_prod.public_key)},
    "private_key": ${jsonencode(yandex_iam_service_account_key.sa_auth_key_prod.private_key)}
  }
  EOH
  filename = ".key_prod.json"
}


output "prod_service_account_id" {
  description = "prod service account ID"
  value       = yandex_iam_service_account.sa_tf_prod.id
}


# ----- черновики-заметки-----------------
# resource "yandex_resourcemanager_folder_iam_member" "acc_binding" {
#   folder_id = data.yandex_resourcemanager_folder.acc_folder[split(":", each.key)[2]].id
#   role      = each.value
#   member    = "serviceAccount:${data.yandex_iam_service_account.acc[join(":", slice(split(":", each.key), 0, 2))].id}"
# }
# ----------------------------------
# resource "yandex_iam_service_account_iam_binding" "iam_editor_for_sa_tf_prod" {
#   service_account_id = ""
#   role               = "<роль>"
#   members            = [
#     "",
#   ]
# }
# ------------------------------------------



# ------------

# # Grant the service account the organization-manager.admin role
# resource "yandex_organizationmanager_organization_iam_binding" "org_admin_for_sa_tf" {
#   organization_id = var.organization_id
#   role            = "organization-manager.admin"
#   members = [
#     "serviceAccount:${yandex_iam_service_account.sa-tf.id}",
#   ]
# }

# # Grant the service account the billing.accounts.editor role
# resource "yandex_organizationmanager_organization_iam_binding" "biling_editor_for_sa_tf" {
#   organization_id = var.organization_id
#   role            = "billing.accounts.editor"
#   members = [
#     "serviceAccount:${yandex_iam_service_account.sa-tf.id}",
#   ]
# }

# # Grant the service account the resource-manager.editor role
# resource "yandex_organizationmanager_organization_iam_binding" "resource_manager_editor_for_sa_tf_prod" {
#   organization_id = var.organization_id
#   role            = "resource-manager.editor"
#   members = [
#     "serviceAccount:${yandex_iam_service_account.sa_tf_prod.id}",
#   ]
# }


# # Grant the service account the iam.admin role
# resource "yandex_organizationmanager_organization_iam_binding" "iam_editor_for_sa_tf_prod" {
#   organization_id = var.organization_id
#   role            = "iam.editor"
#   members = [
#     "serviceAccount:${yandex_iam_service_account.sa_tf_prod.id}",
#   ]
# }


