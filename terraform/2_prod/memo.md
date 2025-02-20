# Вопросы

* имеет ли смысл делать в отдельных папках продовую нагрузку и  tfstate-backend?
* зачем нуждны профили ya cli и нужно ли их активировать? 
* почему бывает не работает через sa  - говорит нет доступа, тогда делаю первый раз через oAuth key - все ок, и потом назад через SA и уже работает.
* как узнать через какой ключ работаем?
* как отозвать ключ?
* добавить автокоммиты
* добавить генерить документацию.
* какие права для SA нужны для создания подсетей и сетей?
* почему не хватает прав на сервисынй аккаунт - каких?:



* ошибка

╷
│ Error: Error while requesting API to create route table: server-request-id = 49c15a61-a0d7-40d3-bc4f-8583032d395d server-trace-id = 556bdb862272d683:e0fffcf27795d0b9:556bdb862272d683:1 cli
ent-request-id = 6f0eb84d-3426-427e-a7ab-31c367e9abe2 client-trace-id = 74d99df4-d673-4962-ae71-8974c4d9701c rpc error: code = PermissionDenied desc = Permission denied to use gateway
│
│   with module.net.yandex_vpc_route_table.private[0],
│   on .terraform\modules\net\main.tf line 78, in resource "yandex_vpc_route_table" "private":
│   78: resource "yandex_vpc_route_table" "private" {
│
╵


│ Error: Error while requesting API to create route table: server-request-id = 1a1f6cb1-5fe3-4c70-824e-f62d477eab7c server-trace-id = 265131a87ebd1119:f04bb0d38590ba48:265131a87ebd1119:1 cli
ent-request-id = 816ce9d7-007e-4b7b-899b-7cd64de107c5 client-trace-id = 5736d2bb-6c20-4c0a-95d5-b4f5f1f58dad rpc error: code = PermissionDenied desc = Permission denied to use gateway
│
│   with module.net.yandex_vpc_route_table.private[0],
│   on .terraform\modules\net\main.tf line 78, in resource "yandex_vpc_route_table" "private":
│   78: resource "yandex_vpc_route_table" "private" {

resource "yandex_vpc_route_table" "private" {
  count      = var.private_subnets == null ? 0 : 1
  name       = "${var.network_name}-private"
  network_id = local.vpc_id
  folder_id  = local.folder_id

  dynamic "static_route" {
    for_each = var.routes_private_subnets == null ? [] : var.routes_private_subnets
    content {
      destination_prefix = static_route.value["destination_prefix"]
      next_hop_address   = static_route.value["next_hop_address"]
    }
  }
  dynamic "static_route" {
    for_each = var.create_nat_gw ? yandex_vpc_gateway.egress_gateway : []
    content {
      destination_prefix = "0.0.0.0/0"
      gateway_id         = yandex_vpc_gateway.egress_gateway[0].id
    }
  }

}

* что значит => v

resource "yandex_vpc_subnet" "private" {
  for_each       = try({ for v in var.private_subnets : v.v4_cidr_blocks[0] => v }, {})