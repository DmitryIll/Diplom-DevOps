# Создаем группы нод кластера
resource "yandex_kubernetes_node_group" "k8_node_a" {
  cluster_id  = "${yandex_kubernetes_cluster.k8s.id}"
  name        = "node-a"
  description = "node-a-k8s"
  # version     = var.k8s_version

  # labels = {
  #   "key" = "value"
  # }
  instance_template {
    platform_id = "standard-v3"
    name = "node-a-{instance.short_id}"

    network_interface {
      nat                = true
      subnet_ids         = [yandex_vpc_subnet.private_a.id]
    }
    resources {
      memory = 8
      cores  = 4
    }
    boot_disk {
      type = "network-hdd"
      size = 64
    }
    scheduling_policy {
      preemptible = true
    }
  }
  scale_policy {
    fixed_scale {
      size = 1
    }
  }
  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }
}

# -------------------------------------------------

resource "yandex_kubernetes_node_group" "k8_node_b" {
  cluster_id  = "${yandex_kubernetes_cluster.k8s.id}"
  name        = "node-b"
  description = "node-b-k8s"
  # version     = var.k8s_version

  # labels = {
  #   "key" = "value"
  # }
  instance_template {
    platform_id = "standard-v3"
    name = "node-b-{instance.short_id}"

    network_interface {
      nat                = true
      subnet_ids         = [yandex_vpc_subnet.private_b.id]
    }
    resources {
      memory = 8
      cores  = 4
    }
    boot_disk {
      type = "network-hdd"
      size = 64
    }
    scheduling_policy {
      preemptible = true
    }
  }
  scale_policy {
    fixed_scale {
      size = 1
    }
  }
  allocation_policy {
    location {
      zone = "ru-central1-b"
    }
  }
}

resource "yandex_kubernetes_node_group" "k8_node_d" {
  cluster_id  = "${yandex_kubernetes_cluster.k8s.id}"
  name        = "node-d"
  description = "node-d-k8s"
  # version     = var.k8s_version

  # labels = {
  #   "key" = "value"
  # }
  instance_template {
    platform_id = "standard-v3"
    name = "node-d-{instance.short_id}"

    network_interface {
      nat                = true
      subnet_ids         = [yandex_vpc_subnet.private_d.id]
    }
    resources {
      memory = 8
      cores  = 4
    }
    boot_disk {
      type = "network-hdd"
      size = 64
    }
    scheduling_policy {
      preemptible = true
    }
  }
  scale_policy {
    fixed_scale {
      size = 1
    }
  }
  allocation_policy {
    location {
      zone = "ru-central1-d"
    }
  }
}







/*
 https://yandex.cloud/ru/docs/managed-kubernetes/operations/node-group/node-group-create

resource "yandex_kubernetes_node_group" "<имя_группы_узлов>" {
  cluster_id = yandex_kubernetes_cluster.<имя_кластера>.id
  name       = "<имя_группы_узлов>"
  ...
  instance_template {
    name       = "<шаблон_имени_узлов>"
    platform_id = "<платформа_для_узлов>"
    network_acceleration_type = "<тип_ускорения_сети>"
    container_runtime {
      type = "containerd"
    }
    labels {
      "<имя_метки>"="<значение_метки>"
    }
    ...
  }
  ...
  scale_policy {
    <настройки_масштабирования_группы_узлов>
  }
}



resource "yandex_kubernetes_node_group" "<имя_группы_узлов>" {
  ...
  scale_policy {
    fixed_scale {
      size = <количество_узлов_в_группе>
    }
  }


resource "yandex_kubernetes_node_group" "<имя_группы_узлов>" {
  ...
  scale_policy {
    auto_scale {
      min     = <минимальное_количество_узлов_в_группе_узлов>
      max     = <максимальное_количество_узлов_в_группе_узлов>
      initial = <начальное_количество_узлов_в_группе_узлов>
    }
  }
}

resource "yandex_kubernetes_node_group" "<имя_группы_узлов>" {
  ...
  instance_template {
    metadata = {
      "ключ_1" = "значение"
      "ключ_2" = file("<путь_к_файлу_со_значением>")
      ...
    }
    ...
  }
  ...
}

resource "yandex_kubernetes_node_group" "<имя_группы_узлов>" {
  ...
  instance_template {
    network_interface {
      ipv4_dns_records {
        fqdn        = "<FQDN_записи_DNS>"
        dns_zone_id = "<идентификатор_зоны_DNS>"
        ttl         = "<TTL_записи_DNS_в_секундах>"
        ptr         = "<создание_PTR_записи>"
      }
    }
  }
}

*/