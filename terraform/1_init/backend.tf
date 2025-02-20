terraform {
  backend "s3" {
    region         = "ru-central1"
    bucket         = "init-qky0"
    key            = "init"

    dynamodb_table = "state-lock-table"

    endpoints = {
      s3       = "https://storage.yandexcloud.net",
      dynamodb = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gb78r3d0luhtuca6rh/etni5ao06822gbn4v1q3"
    }

    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}
