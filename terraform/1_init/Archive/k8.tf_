resource "yandex_kubernetes_cluster" "k8s" {
  name = "k8-prod"
  network_id = yandex_vpc_network.prod_net.id
  network_policy_provider = "CALICO"
  # version = var.k8s_ver
  # public_ip = true
  master {
    master_location {
      zone      = yandex_vpc_subnet.private_a.zone
      subnet_id = yandex_vpc_subnet.private_a.id
    }
    master_location {
      zone      = yandex_vpc_subnet.private_b.zone
      subnet_id = yandex_vpc_subnet.private_b.id
    }
    master_location {
      zone      = yandex_vpc_subnet.private_d.zone
      subnet_id = yandex_vpc_subnet.private_d.id
    }
    security_group_ids = [yandex_vpc_security_group.k8s-public-services.id]
  }
  # master {
  #   master_location {
  #     zone      = yandex_vpc_subnet.private_a.zone
  #     subnet_id = yandex_vpc_subnet.private_a.id
  #   }
  #   security_group_ids = [yandex_vpc_security_group.k8s-public-services.id]
  # }
  service_account_id      = yandex_iam_service_account.sa_tf.id
  node_service_account_id = yandex_iam_service_account.sa_tf.id

  depends_on = [
     yandex_resourcemanager_folder_iam_member.editor,
     yandex_resourcemanager_folder_iam_member.container-registry_images_puller
   ]

  kms_provider {
    key_id = yandex_kms_symmetric_key.kms_key.id
  }
  
}

# -----------
#  https://yandex.cloud/ru/docs/managed-kubernetes/operations/kubernetes-cluster/kubernetes-cluster-create

# resource "yandex_kubernetes_cluster" "k8s-zonal" {
#   name = "k8s-zonal"
#   network_id = yandex_vpc_network.mynet.id
#   master {
#     master_location {
#       zone      = yandex_vpc_subnet.mysubnet.zone
#       subnet_id = yandex_vpc_subnet.mysubnet.id
#     }
#     security_group_ids = [yandex_vpc_security_group.k8s-public-services.id]
#   }
#   service_account_id      = yandex_iam_service_account.myaccount.id
#   node_service_account_id = yandex_iam_service_account.myaccount.id
#   depends_on = [
#     yandex_resourcemanager_folder_iam_member.k8s-clusters-agent,
#     yandex_resourcemanager_folder_iam_member.vpc-public-admin,
#     yandex_resourcemanager_folder_iam_member.images-puller,
#     yandex_resourcemanager_folder_iam_member.encrypterDecrypter
#   ]
#   kms_provider {
#     key_id = yandex_kms_symmetric_key.kms-key.id
#   }
# }

# resource "yandex_vpc_network" "mynet" {
#   name = "mynet"
# }

# resource "yandex_vpc_subnet" "mysubnet" {
#   name = "mysubnet"
#   v4_cidr_blocks = ["10.1.0.0/16"]
#   zone           = "ru-central1-a"
#   network_id     = yandex_vpc_network.mynet.id
# }

# resource "yandex_iam_service_account" "myaccount" {
#   name        = "zonal-k8s-account"
#   description = "K8S zonal service account"
# }

# resource "yandex_resourcemanager_folder_iam_member" "k8s-clusters-agent" {
#   # Сервисному аккаунту назначается роль "k8s.clusters.agent".
#   folder_id = local.folder_id
#   role      = "k8s.clusters.agent"
#   member    = "serviceAccount:${yandex_iam_service_account.myaccount.id}"
# }

# resource "yandex_resourcemanager_folder_iam_member" "vpc-public-admin" {
#   # Сервисному аккаунту назначается роль "vpc.publicAdmin".
#   folder_id = local.folder_id
#   role      = "vpc.publicAdmin"
#   member    = "serviceAccount:${yandex_iam_service_account.myaccount.id}"
# }

# resource "yandex_resourcemanager_folder_iam_member" "images-puller" {
#   # Сервисному аккаунту назначается роль "container-registry.images.puller".
#   folder_id = local.folder_id
#   role      = "container-registry.images.puller"
#   member    = "serviceAccount:${yandex_iam_service_account.myaccount.id}"
# }

# resource "yandex_resourcemanager_folder_iam_member" "encrypterDecrypter" {
#   # Сервисному аккаунту назначается роль "kms.keys.encrypterDecrypter".
#   folder_id = local.folder_id
#   role      = "kms.keys.encrypterDecrypter"
#   member    = "serviceAccount:${yandex_iam_service_account.myaccount.id}"
# }

# resource "yandex_kms_symmetric_key" "kms-key" {
#   # Ключ Yandex Key Management Service для шифрования важной информации, такой как пароли, OAuth-токены и SSH-ключи.
#   name              = "kms-key"
#   default_algorithm = "AES_128"
#   rotation_period   = "8760h" # 1 год.
# }

# ----------------------

# resource "yandex_kubernetes_cluster" "k8s-regional" {
#   name = "k8s-regional"
#   network_id = yandex_vpc_network.my-regional-net.id
#   master {
#     master_location {
#       zone      = yandex_vpc_subnet.mysubnet-a.zone
#       subnet_id = yandex_vpc_subnet.mysubnet-a.id
#     }
#     master_location {
#       zone      = yandex_vpc_subnet.mysubnet-b.zone
#       subnet_id = yandex_vpc_subnet.mysubnet-b.id
#     }
#     master_location {
#       zone      = yandex_vpc_subnet.mysubnet-d.zone
#       subnet_id = yandex_vpc_subnet.mysubnet-d.id
#     }
#     security_group_ids = [yandex_vpc_security_group.regional-k8s-sg.id]
#   }
#   service_account_id      = yandex_iam_service_account.my-regional-account.id
#   node_service_account_id = yandex_iam_service_account.my-regional-account.id
#   depends_on = [
#     yandex_resourcemanager_folder_iam_member.k8s-clusters-agent,
#     yandex_resourcemanager_folder_iam_member.vpc-public-admin,
#     yandex_resourcemanager_folder_iam_member.images-puller,
#     yandex_resourcemanager_folder_iam_member.encrypterDecrypter
#   ]
#   kms_provider {
#     key_id = yandex_kms_symmetric_key.kms-key.id
#   }
# }