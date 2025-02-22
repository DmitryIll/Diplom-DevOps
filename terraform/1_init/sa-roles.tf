# folders

resource "yandex_resourcemanager_folder_iam_member" "vpc_folder_admin_prod" {
  folder_id = module.init.folders[0].id 
  role     = "vpc.admin"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "folder_compute_admin_prod" {
  folder_id = module.init.folders[0].id 
  role     = "compute.admin"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "folder_compute_osLogin_prod" {
  folder_id = module.init.folders[0].id 
  role     = "compute.osLogin"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "folder_compute_operator_prod" {
  folder_id = module.init.folders[0].id 
  role     = "compute.operator"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "folder_resource_manager_admin_prod" {
  folder_id = module.init.folders[0].id 
  role     = "resource-manager.admin"
  member =  "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "foder_IAM_admin_prod" {
  folder_id = module.init.folders[0].id 
  role     = "iam.admin"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
}



resource "yandex_resourcemanager_folder_iam_member" "folder_vpc_user_prod" {
  folder_id = module.init.folders[0].id 
  role     = "vpc.user"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
}

#  clouds

resource "yandex_resourcemanager_cloud_iam_member" "vpc_admin_prod" {
  cloud_id = module.init.cloud_id #var.cloud_prod_id 
  role     = "vpc.admin"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
}


resource "yandex_resourcemanager_cloud_iam_member" "vpc_user_prod" {
  cloud_id = module.init.cloud_id #var.cloud_prod_id 
  role     = "vpc.user"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
}


resource "yandex_resourcemanager_cloud_iam_member" "cloud_resource_manager_admin_prod" {
  cloud_id = module.init.cloud_id #var.cloud_prod_id 
  role     = "resource-manager.admin"
  member =  "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
}




resource "yandex_resourcemanager_cloud_iam_member" "cloud_IAM_admin_prod" {
  cloud_id = module.init.cloud_id #var.cloud_prod_id 
  role     = "iam.admin"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
}


resource "yandex_resourcemanager_cloud_iam_member" "vpc_gateways_editor_prod" {
  cloud_id = module.init.cloud_id #var.cloud_prod_id 
  role     = "vpc.gateways.editor"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
}


resource "yandex_resourcemanager_cloud_iam_member" "vpc_privateEndpoints_admin_prod" {
  cloud_id = module.init.cloud_id #var.cloud_prod_id 
  role     = "vpc.privateEndpoints.admin"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
}

resource "yandex_resourcemanager_cloud_iam_member" "vpc_securityGroups_admin_prod" {
  cloud_id = module.init.cloud_id #var.cloud_prod_id 
  role     = "vpc.securityGroups.admin"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
}

resource "yandex_resourcemanager_cloud_iam_member" "vpc_privateAdmin_prod" {
  cloud_id = module.init.cloud_id #var.cloud_prod_id 
  role     = "vpc.privateAdmin"
  member = "serviceAccount:${yandex_iam_service_account.sa_tf.id}"
}
