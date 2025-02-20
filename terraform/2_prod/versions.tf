terraform {
  required_version = ">= 1.3.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.134"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.44"
    }
    random = {
      source  = "hashicorp/random"
      version = "> 3.5"
    }
  }
}

# provider "yandex" {
# }

provider "yandex" {
  # token = file(".yctoken")
  service_account_key_file = file(".key_prod.json")
  # service_account_key_file = file(".key.json")
  # cloud_id = var.organization_id
  # folder_id = "b1goqpmqf33kl450j47i"
  # zone = local.zone
}

provider "aws" {
  region                      = "eu-west-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = yandex_iam_service_account_static_access_key.sa_tf_static_key_prod.access_key
  secret_key                  = yandex_iam_service_account_static_access_key.sa_tf_static_key_prod.secret_key
  endpoints {
    dynamodb = yandex_ydb_database_serverless.database_prod.document_api_endpoint
  }
}
