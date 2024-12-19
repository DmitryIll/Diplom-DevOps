terraform {
  required_providers {
    # нужен для создания AWS DynamoDB Table
      aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
    }

    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

# https://yandex.cloud/ru/docs/tutorials/infrastructure-management/terraform-state-storage?ysclid=m2r6fao3i0813182788 

# Конфиг который определяет где будет храниться tarraform.tfstate
# при первом запуске пока еще нет S3 в облаке - закоментировать
# при втором запуске - раскомментировать - tfsate переедет в S3.

# /* ----- S3 будем делать уже в другом проекте
backend "s3" {
    
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    # endpoint = "https://storage.yandexcloud.net"
    bucket = "s3bucket-trr"
    region = "ru-central1-a"
    key    = "initpoject/terraform.tfstate"
    profile = "default"

    # dynamodb_table = "tfstate-lock-diplom"
    dynamodb_table = "tflock-dip"
     dynamodb_endpoint = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gq7flktn6couidedto/etn47ui4t7bbudrrojtc"
    # dynamodb_endpoint = "${file("./dynamodbapi")}"
     skip_region_validation      = true
     skip_credentials_validation = true

     skip_requesting_account_id  = true # необходимая опция при описании бэкенда для Terraform версии 1.6.1 и старше.
     skip_s3_checksum            = true # необходимая опция при описании бэкенда для Terraform версии 1.6.3 и старше.
   }
# */

}

provider "yandex" {
  token = "${file("./yctoken")}"
  cloud_id = "${file("./cloudid")}"
  folder_id = local.folder_id
  # folder_id = "${file("./folderid")}"
  zone = local.zone
}


# нужен для работы с динамо DB таблицей - которая нужна для блокировок tfstate.
provider "aws" {
  region = "ru-central1"
  # тут нужно обновить ендпоинт, после создания S3
  endpoints {
    dynamodb = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gq7flktn6couidedto/etn47ui4t7bbudrrojtc"
  }
  # profile = "<profile_name>"
  skip_credentials_validation = true
  skip_metadata_api_check = true
  skip_region_validation = true
  skip_requesting_account_id = true
}