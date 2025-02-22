resource "yandex_kubernetes_cluster" "k8s_cluster" {
  name = "k8s"
  network_id = yandex_vpc_network.prod_net.id
  network_policy_provider = "CALICO"
  master {
    version = var.k8s_ver
    public_ip = true
    regional {
      region = "ru-central1"
      location {
        zone      = yandex_vpc_subnet.prv_a.zone
        subnet_id = yandex_vpc_subnet.priv_a.id
      }
    #   location {
    #     zone      = yandex_vpc_subnet.prv_b.zone
    #     subnet_id = yandex_vpc_subnet.prv_b.id
    #   }
    #   location {
    #     zone      = yandex_vpc_subnet.prv_d.zone
    #     subnet_id = yandex_vpc_subnet.prv_d.id
    #   }
    }
  }
  
  
  service_account_id      = yandex_iam_service_account.sa_tf.id
  node_service_account_id = yandex_iam_service_account.sa_tf.id

#   depends_on = [
#     yandex_resourcemanager_folder_iam_member.editor,
#     yandex_resourcemanager_folder_iam_member.images-puller
#   ]

  kms_provider {
    key_id = yandex_kms_symmetric_key.kms_key.id
  }
}
