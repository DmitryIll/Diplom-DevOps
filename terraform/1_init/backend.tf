terraform {
  backend "s3" {
    region         = "ru-central1"
    bucket         = "init-8gcp"
    key            = "init"

    dynamodb_table = "state-lock-table"

    endpoints = {
      s3       = "https://storage.yandexcloud.net",
      dynamodb = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gjo1f0ugngaqfdnp1h/etnq8i74bjn00na2v5oj"
    }

    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}
