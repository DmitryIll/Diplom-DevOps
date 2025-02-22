#  https://yandex.cloud/ru/docs/managed-kubernetes/security/#yc-api
# k8s.cluster-api.viewer
# k8s.cluster-api.editor
# k8s.cluster-api.cluster-admin
# k8s.tunnelClusters.agent
# k8s.admin
# k8s.clusters.agent

# resource "yandex_resourcemanager_folder_iam_member" "" {
#   folder_id = module.init.folders[0].id 
#   role     = ""
#   member = "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
# }

resource "yandex_resourcemanager_folder_iam_member" "container-registry_images_puller" {
  folder_id = module.init.folders[0].id 
  role     = "container-registry.images.puller"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
}


resource "yandex_resourcemanager_folder_iam_member" "load_balancer_admin" {
  folder_id = module.init.folders[0].id 
  role     = "load-balancer.admin"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
}


resource "yandex_resourcemanager_folder_iam_member" "k8s_tunnelClusters_agent" {
  folder_id = module.init.folders[0].id 
  role     = "k8s.tunnelClusters.agent"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s_admin" {
  folder_id = module.init.folders[0].id 
  role     = "k8s.admin"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s_clusters_agent" {
  folder_id = module.init.folders[0].id 
  role     = "k8s.clusters.agent"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s_cluster_api_cluster_admin" {
  folder_id = module.init.folders[0].id 
  role     = "k8s.cluster-api.cluster-admin"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
}





