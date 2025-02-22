resource "yandex_compute_instance" "priv_vm" {

  name = "priv-vm" 
  hostname = "priv-vm" 

  allow_stopping_for_update = true
  platform_id               = "standard-v1"
  zone                      = "ru-central1-a"

  network_interface {
    subnet_id = "${yandex_vpc_subnet.private_a.id}" 
    # ip_address = "192.168.20.10"
    # nat       = "true"
  }

  resources {
    core_fraction = 20 
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd82nvvtllmimo92uoul"   # ubuntu 22.04
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

output "priv_vm_ip" {
   value="${yandex_compute_instance.priv_vm.network_interface.0.ip_address}"
}

output "priv_vm_ip_nat" {
   value="${yandex_compute_instance.priv_vm.network_interface.0.nat_ip_address}"
}

