#---- vms --------------

resource "yandex_compute_instance" "nat" {

  name = "nat" 
  hostname = "nat" 

  allow_stopping_for_update = true
  platform_id               = "standard-v1"
  zone                      = "ru-central1-a"

  network_interface {
    subnet_id = "${yandex_vpc_subnet.public_a.id}" 
    ip_address = "10.1.1.254"
    nat       = "true"
  }

  resources {
    core_fraction = 20 
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
      size = "16"
    }
  }


  scheduling_policy {
    preemptible = "true"
   }

 metadata = {
    user-data = "${file("./meta.yaml")}" 
  }
}

output "nat_external_ip" {
   value="${yandex_compute_instance.nat.network_interface.0.nat_ip_address}"
}

output "nat_internal_ip" {
   value="${yandex_compute_instance.nat.network_interface.0.ip_address}"
}

