# # Назначение роли сервисному аккаунту для YDB
# resource "yandex_resourcemanager_folder_iam_member" "ydb_editor" {
#   folder_id = local.folder_id
#   role      = "ydb.editor" 
#   member    = "serviceAccount:${yandex_iam_service_account.sa_trr.id}"
#   depends_on = [yandex_iam_service_account.sa_trr]
# }

# # Назначение роли  kms.editor сервисному аккаунту для kubernetis
# resource "yandex_resourcemanager_folder_iam_member" "kms_editor" {
#   folder_id = local.folder_id
#   role      = "kms.editor" 
#   member    = "serviceAccount:${yandex_iam_service_account.sa_trr.id}"
#   depends_on = [yandex_iam_service_account.sa_trr]
# }