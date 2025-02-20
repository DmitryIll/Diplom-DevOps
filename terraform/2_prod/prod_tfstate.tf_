# Grant the service account the storage.admin role
resource "yandex_resourcemanager_folder_iam_member" "sa_tf_editor_s3_prod" {
  folder_id = local.folder_id_prod
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa_tf_prod.id}"
}

# Grant the service account the kms.editor role
resource "yandex_resourcemanager_folder_iam_member" "sa_tf_editor_kms_prod" {
  folder_id = local.folder_id_prod
  role      = "kms.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa_tf_prod.id}"
}

# Grant the service account the ydb.editor role
resource "yandex_resourcemanager_folder_iam_member" "sa_tf_editor_ydb_prod" {
  folder_id = local.folder_id_prod
  role      = "ydb.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa_tf_prod.id}"
}

# Create a static access key
resource "yandex_iam_service_account_static_access_key" "sa_tf_static_key_prod" {
  service_account_id = yandex_iam_service_account.sa_tf_prod.id
  description        = "Static access key for bucket ${local.prod_bucket_name} and YDB"
}

module "state_bucket_prod" {
  # source      = "git::https://github.com/terraform-yc-modules/terraform-yc-s3.git?ref=1.0.4"
  source      = "git::https://github.com/DmitryIll/terraform-yc-s3.git"
  bucket_name = local.prod_bucket_name
  folder_id   = local.folder_id_prod
  versioning = {
    enabled = true
  }
  server_side_encryption_configuration = {
    enabled = true
  }
  lifecycle_rule = [{
    enabled = true
    noncurrent_version_expiration = {
      days = 60
    }
  }]

}

# Create a YDB database for the state file lock
resource "yandex_ydb_database_serverless" "database_prod" {
  name      = "${var.prod_prefix}-ydb"
  folder_id = local.folder_id_prod
}

# Wait 60 sec after YDB creation
resource "time_sleep" "wait_for_database_prod" {
  create_duration = "60s"
  depends_on      = [yandex_ydb_database_serverless.database_prod]
}

# Create a table in YDB for the state file lock
resource "aws_dynamodb_table" "lock_table_prod" {
  name         = "state-lock-table-prod"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
  depends_on = [time_sleep.wait_for_database_prod, yandex_resourcemanager_folder_iam_member.sa_tf_editor_ydb_prod, yandex_iam_service_account_static_access_key.sa_tf_static_key_prod]
}

# Create a .env file with access keys
resource "local_file" "env_prod" {
  content  = <<EOF
export AWS_ACCESS_KEY_ID="${yandex_iam_service_account_static_access_key.sa_tf_static_key_prod.access_key}"
export AWS_SECRET_ACCESS_KEY="${yandex_iam_service_account_static_access_key.sa_tf_static_key_prod.secret_key}"
EOF
  filename = ".env_prod"
}

# Script .create-profile-<service_account_name>.sh to create a YC profile for service account
resource "local_file" "create_yc_profile_prod" {
  content  = <<EOF
#!/bin/bash
yc config profile create ${yandex_iam_service_account.sa_tf_prod.name}
yc config set organization-id ${var.organization_id}
yc config set cloud-id ${var.cloud_prod_id}
yc config set folder-id ${var.cloud_prod_folders[0].id}
yc config set service-account-key .key_prod.json
EOF
  filename = ".create-profile-${yandex_iam_service_account.sa_tf_prod.name}.sh"
}

# Script .activate-profile-<service_account_name>.sh to activate YC profile for service account
resource "local_file" "activate_yc_profile_prod" {
  content  = <<EOF
#!/bin/bash
yc config profile activate ${yandex_iam_service_account.sa_tf_prod.name}
export YC_TOKEN=$(yc iam create-token)
export IAM_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
source .env_prod
EOF
  filename = ".activate-profile-${yandex_iam_service_account.sa_tf_prod.name}.sh"
}

# Instructions regarding how to migrate to remote Terraform state
output "backend_tf_textnote_prod" {
  value = <<EOF
***************
To migrate to remote Terraform state follow this steps:
1. From the output `backend_tf_prod` copy all text between EOH tags and paste into new `backend_prod.tf` file.
2. Initialize environment variables from `.env` file (`source ./.env_prod`).
3. Run `terraform init -migrate-state` to migrate to remote state.

Optionally:
- to create and configure new YC profile for service account `${yandex_iam_service_account.sa_tf_prod.name}` execute:
  ./.create-profile-${yandex_iam_service_account.sa_tf_prod.name}.sh
  source ./.activate-profile-${yandex_iam_service_account.sa_tf_prod.name}.sh
***************
EOF
}

# Remote backend configuration file content
output "backend_tf_prod" {
  description = "Remote backend configuration file content.  (see README.md for details)"
  value       = <<EOF
terraform {
  backend "s3" {
    region         = "ru-central1"
    bucket         = "${module.state_bucket_prod.bucket_name}"
    key            = "${var.prod_prefix}"

    dynamodb_table = "${aws_dynamodb_table.lock_table_prod.id}"

    endpoints = {
      s3       = "https://storage.yandexcloud.net",
      dynamodb = "${yandex_ydb_database_serverless.database_prod.document_api_endpoint}"
    }

    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}
EOF
}

resource "local_file" "backend_tf_prod" {
  content  = <<EOF
terraform {
  backend "s3" {
    region         = "ru-central1"
    bucket         = "${module.state_bucket_prod.bucket_name}"
    key            = "${var.prod_prefix}"

    dynamodb_table = "${aws_dynamodb_table.lock_table_prod.id}"

    endpoints = {
      s3       = "https://storage.yandexcloud.net",
      dynamodb = "${yandex_ydb_database_serverless.database_prod.document_api_endpoint}"
    }

    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}
EOF
  filename = "backend_prod.tf"
}