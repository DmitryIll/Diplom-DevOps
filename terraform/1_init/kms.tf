locals {
  kms_name        = "k8s-kms-key"
  kms_key_with_id = "${local.kms_name}-${random_string.unique_id.result}"
}
resource "yandex_kms_symmetric_key" "kms_key" {
  folder_id         = local.folder_id
  name              = local.kms_key_with_id
  default_algorithm = "AES_256"
  rotation_period   = "8760h"
}

resource "yandex_kms_symmetric_key_iam_binding" "k8_encrypter_decrypter" {
  symmetric_key_id = yandex_kms_symmetric_key.kms_key.id
  role             = "kms.keys.encrypterDecrypter"
  members = [
    "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
  ]
}