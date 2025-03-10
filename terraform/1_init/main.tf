locals {
  folder_id             = module.init.folders[0].id
  init_bucket_name = "${var.init_prefix}-${random_string.unique_id.result}"
}

resource "random_string" "unique_id" {
  length  = 4
  upper   = false
  lower   = true
  numeric = true
  special = false
}

# Service account supposed to be used as the main subject to run org-level privileged operations (create cloud etc.)
resource "yandex_iam_service_account" "sa_tf" {
  name        = "sa-tf"
  description = "Service account for Terraform"
  folder_id   = local.folder_id
}


# Create an authorized access key for the service account
resource "yandex_iam_service_account_key" "sa_auth_key" {
  service_account_id = yandex_iam_service_account.sa_tf.id
  description        = "Key for service account"
  key_algorithm      = "RSA_2048"
}

# Export the key to a file (.key.json) to create a YC profile later
resource "local_file" "key" {
  content  = <<EOH
  {
    "id": "${yandex_iam_service_account_key.sa_auth_key.id}",
    "service_account_id": "${yandex_iam_service_account.sa_tf.id}",
    "created_at": "${yandex_iam_service_account_key.sa_auth_key.created_at}",
    "key_algorithm": "${yandex_iam_service_account_key.sa_auth_key.key_algorithm}",
    "public_key": ${jsonencode(yandex_iam_service_account_key.sa_auth_key.public_key)},
    "private_key": ${jsonencode(yandex_iam_service_account_key.sa_auth_key.private_key)}
  }
  EOH
  filename = ".key.json"
}

output "init_service_account_id" {
  description = "init service account ID"
  value       = yandex_iam_service_account.sa_tf.id
}
