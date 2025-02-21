#---- Создани подсети нужна одна на все ВМ --------------

resource "yandex_vpc_network" "prod_net" {
  name = "prod-net"
}

resource "yandex_vpc_subnet" "public_a" {
  name           = "public-a"
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["10.1.1.0/24"]
  network_id     = "${yandex_vpc_network.prod-net.id}"
}

# resource "yandex_vpc_subnet" "public_b" {
#   name           = "public-b"
#   zone           = "ru-central1-b"
#   v4_cidr_blocks = ["10.1.2.0/24"]
#   network_id     = "${yandex_vpc_network.prod-net.id}"
# }

# resource "yandex_vpc_subnet" "public_d" {
#   name           = "public-d"
#   zone           = "ru-central1-d"
#   v4_cidr_blocks = ["10.1.3.0/24"]
#   network_id     = "${yandex_vpc_network.prod-net.id}"
# }

resource "yandex_vpc_subnet" "private_a" {
  name           = "private-a"
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["10.2.1.0/24"]
  network_id     = "${yandex_vpc_network.pod_net.id}"
  route_table_id = yandex_vpc_route_table.rt_priv.id
}


resource "yandex_vpc_route_table" "rt_priv" {
  name       = "rt-priv"
  network_id = "${yandex_vpc_network.prod_net.id}"

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.nat.network_interface.0.ip_address #yandex_vpc_gateway.nat_gateway.id
  }
}