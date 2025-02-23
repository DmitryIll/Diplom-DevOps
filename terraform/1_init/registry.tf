resource "yandex_container_registry" "reg" {
  name = "registr-prod"
  folder_id = local.folder_id
#   labels = {
#     my-label = "my-label-value"
#   }
}

resource "yandex_container_registry_iam_binding" "имя_реестра" {
  registry_id = yandex_container_registry.reg.id
  role        = "container-registry.editor"

  members = [
    "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
  ]
  depends_on = [yandex_resourcemanager_cloud_iam_member.cloud-registry_editor]
}

# resource "yandex_container_registry_iam_binding" "puller" {
#   registry_id = yandex_container_registry.your-registry.id
#   role        = "container-registry.images.puller"

#   members = [
#     "system:allUsers",
#   ]
# }

# resource "yandex_container_registry_iam_binding" "имя_реестра" {
#   registry_id = "<идентификатор_реестра>"
#   role        = "<роль>"

#   members = [
#     "userAccount:<идентификатор_пользователя>",
#   ]
# }

#  Роли:
# container-registry.editor
# container-registry.admin
# container-registry.images.pusher
# container-registry.images.puller
# container-registry.images.scanner


# resource "yandex_container_registry_ip_permission" "my_ip_permission" {
#   registry_id = yandex_container_registry.my_registry.id
#   push        = ["10.1.0.0/16", "10.2.0.0/16", "10.3.0.0/16"]
#   pull        = ["10.1.0.0/16", "10.5.0/16"]
# }


#  --- репозиторий ---

// Create a new Container Registry and new Repository with it.
# resource "yandex_container_registry" "my-registry" {
#   name = "test-registry"
# }

# resource "yandex_container_repository" "my-repository" {
#   name = "${yandex_container_registry.my-registry.id}/test-repository"
# }

# resource "yandex_container_repository_iam_binding" "имя_репозитория" {
#   repository_id = "<идентификатор_репозитория>"
#   role          = "<роль>"

#   members = [
#     "serviceAccount:<идентификатор_сервисного_аккаунта>",
#   ]
# }

# https://yandex.cloud/ru/docs/container-registry/operations/authentication#iam-token_1
# container-registry.images.puller

# echo <IAM-токен>|docker login \
#   --username iam \
#   --password-stdin \
#   cr.yandex


    # <IAM-токен> — тело полученного ранее IAM-токена.
    # --username — тип токена: значение iam указывает на то, что для аутентификации используется IAM-токен.
    # cr.yandex — эндпоинт, к которому будет обращаться 

    # yc container registry configure-docker

#     В конфигурационном файле ${HOME}/.docker/config.json должна появиться строка:

# "cr.yandex": "yc"


# docker push cr.yandex/<идентификатор_реестра>/<имя_Docker-образа>

# yc container image list --repository-name=<идентификатор_реестра>/<имя_Docker-образа>

# yc container registry list-access-bindings <имя_или_идентификатор_реестра>
# yc container repository list-access-bindings <имя_или_идентификатор_репозитория>









# Обратиться к определенной версии Docker-образа можно одним из способов:

#     <реестр>/<имя_образа>:<тег>;
#     <реестр>/<имя_образа>@<хеш>.


//
// Create a new Container Repository and new IAM Binding for it.
//
# resource "yandex_container_registry" "your-registry" {
#   folder_id = "your-folder-id"
#   name      = "registry-name"
# }

# resource "yandex_container_repository" "repo-1" {
#   name = "${yandex_container_registry.your-registry.id}/repo-1"
# }

# resource "yandex_container_repository_iam_binding" "puller" {
#   repository_id = yandex_container_repository.repo-1.id
#   role          = "container-registry.images.puller"

#   members = [
#     "system:allUsers",
#   ]
# }