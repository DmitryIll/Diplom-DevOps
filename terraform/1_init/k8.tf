resource "yandex_kubernetes_cluster" "k8s_cluster" {
  name = "k8-prod"
  network_id = yandex_vpc_network.prod_net.id
  network_policy_provider = "CALICO"
  version = var.k8s_ver
  public_ip = true
  master {
    master_location {
      zone      = yandex_vpc_subnet.private_a.zone
      subnet_id = yandex_vpc_subnet.private_a.id
    }
  }
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
