#-------- создание целевой группы -------

resource "yandex_lb_network_load_balancer" "lb_site" {
  name = "my-network-load-balancer"

  listener {
    name = "lb-site"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = "${yandex_lb_target_group.lb_group.id}"

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}



resource "yandex_lb_target_group" "lb_group" {
  name      = "lb-group" 
#   region_id = "ru-central1" 

  target {
    subnet_id = yandex_vpc_subnet.private_a.id
    address   = "10.2.1.22"
  }
}


output "external_ip_address_lb" {
  value = [
    for listener in yandex_lb_network_load_balancer.lb_site.listener :
    listener.external_address_spec
  ]
}
