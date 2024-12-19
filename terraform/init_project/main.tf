/*
------------------------------------------------------------------------------------------------------------------
Инициализирующий проект - создает:
- сервисный аккаунт и роли к нему для работы с S3
- создает S3 хранилище в облаке для хранения tfstate.
- создает YDB + таблицу Dynamo Table для хранения блокировок tfstate
Не создаем:
- сети - это уже в другом проекте.
- другие роли для SA например для управления кубернетисом - это уже в другом проекте.
------------------------------------------------------------------------------------------------------------------

 Перед началом инициализации можо очистить облако вручную и удалить старые файлы в .terraform, terraform.tfstate, .terraform.lock.hcl .
 0. Выполнить инициализацию trr init
 
 1. Запуск выполнять в несколько заходов:

* Если получаем ошибку:

│ Error: No valid credential sources found
│
│   with provider["registry.terraform.io/hashicorp/aws"],
│   on providers.tf line 57, in provider "aws":
│   57: provider "aws" {
│
│ Please see https://registry.terraform.io/providers/hashicorp/aws
│ for more information about providing credentials.
│
│ Error: failed to refresh cached credentials, no EC2 IMDS role found, operation error ec2imds: GetMetadata,
│ access disabled to EC2 IMDS via client option, or "AWS_EC2_METADATA_DISABLED" environment variable

То нужно создать файл в SSH выполнить:


cat >~/.aws/credentials <<EOL
[default]
aws_access_key_id = aaa
aws_secret_access_key = aaa 
EOL

Ключи потом подредактируем.

Запускаем и создаем s3 при этом в  блоке провайдерс должно быть закоментировано - # backend "s3" {...
    т.е.  tfstate в этом проекте храним локально, чтобы не удалять эти объекты в других преоктах при destroy.
    После первого запуска будет ошибка (и это нормально):

-----------------
Error: creating AWS DynamoDB Table (tflock-dip): operation error DynamoDB: CreateTable, https response error StatusCode: 403, RequestID: 9c
d25027-795c-43a7-97df-ad7379767b4b, api error AccessDeniedException: request-id = 9cd25027-795c-43a7-97df-ad7379767b4b rpc error: code = Unau
thenticated desc = Access key 'YCAJEuOpqAtivVMgESAm7mgqq' not found
│
│   with aws_dynamodb_table.tflock-dip,
│   on main.tf line 91, in resource "aws_dynamodb_table" "tflock-dip":
│   91: resource "aws_dynamodb_table" "tflock-dip" {
-----------------

Для решения указать уже созданные ключи в файле credentials:
Смотрим в terrafromtfstate значения: 
yandex_iam_service_account_static_access_key.sa_static_key_trr.access_key
yandex_iam_service_account_static_access_key.sa_static_key_trr.secret_key
И заносим в:
$ nano ~/.aws/credentials

Можно попробовать автоматизировать - из trr создавтаь файл с ключами (в плане не будущее).

3. Дале запускаем и будет ошибка:

aws_dynamodb_table.tflock-dip: Creating...
╷
│ Error: creating AWS DynamoDB Table (tflock-dip): operation error DynamoDB: CreateTable, https response error StatusCode: 400, RequestID: e6
d0c5b2-24cb-4924-a220-0c8fa631608f, api error ResourceNotFoundException: Database "/ru-central1/b1gq7flktn6couidedto/etnroaeqlfic3bak8qou" no
t ready to serve requests
│
│   with aws_dynamodb_table.tflock-dip,
│   on main.tf line 91, in resource "aws_dynamodb_table" "tflock-dip":
│   91: resource "aws_dynamodb_table" "tflock-dip" {


Решение: в profvider.tf обновить ендпоинт:
Взять значение можно из консоли (или из tfstate файла):

$ trr console
> yandex_ydb_database_serverless.db_tfstate_lock.document_api_endpoint
"https://docapi.serverless.yandexcloud.net/ru-central1/b1gq7flktn6couidedto/etnmqvrg8ot6pkf3c5ii"
> exit

Занести в блок:

provider "aws" {
  region = "ru-central1"
  # тут нужно обновить ендпоинт, после создания S3
  endpoints {
    dynamodb = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gq7flktn6couidedto/etnmqvrg8ot6pkf3c5ii"
  }

И занести пока в закоментированный блок S3
     dynamodb_endpoint = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gq7flktn6couidedto/etnnnkgvisikt3bnk5l6"


4. Еще раз запустить, получим:
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

5. Переносим текущее состояние tfstate в S3:


Раскомментировать в providers.tf блок backend "s3" {...
точнее закоментировать многострочный комментарий (и там где закрывается многострочный ком.):
 # /* ----- S3 будем делать уже в другом проекте 
 

   и Выполнить:
   $ trr init

Доработать на будущее:
 ------------
 │ Warning: Deprecated Parameter
│
│   on providers.tf line 35, in terraform:
│   35:      dynamodb_endpoint = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gq7flktn6couidedto/etnmdfst04amn0pfieoh"
│
│ The parameter "dynamodb_endpoint" is deprecated. Use parameter "endpoints.dynamodb" instead.
--------------------------
   
     
   ответить yes на:

Do you want to copy existing state to the new backend?
  Pre-existing state was found while migrating the previous "local" backend to the
  newly configured "s3" backend. No existing state was found in the newly
  configured "s3" backend. Do you want to copy this state to the new "s3"
  backend? Enter "yes" to copy and "no" to start with an empty state.

  Enter a value: yes

Итого должно быть:
Terraform has been successfully initialized!
при этом локальнй terraform.tfstate должен стать пустым, и его можно будет удалить.
------------

Для удаления:
trr destroy

Можем получить ошибку:

│ Error: deleting AWS DynamoDB Table (tflock-dip): operation error DynamoDB: DeleteTable, https response error Stat
usCode: 403, RequestID: e1fb0072-62e3-4850-b70d-35dec0c0c86c, api error AccessDeniedException: failed to authorize
user: request-id = e1fb0072-62e3-4850-b70d-35dec0c0c86c rpc error: code = PermissionDenied desc = Permission denied
│

Но, это ок, т.к. БД удалена уже или ключ доступа и SA удалены уже.
Можо попробовать добавить зависимость при создании таблицы и yadb от объектов (видимо), тогда возможно не будет проблем с удалением.

------------------------------------------------------------------------------------------------------
*/


# Создаем сервисный аккаунт для terraform в т.ч. для работы с S3 backet
resource "yandex_iam_service_account" "sa_trr" {
  folder_id = local.folder_id
  name      = "sa-trr"
}

# Назначение роли сервисному аккаунту для S3
resource "yandex_resourcemanager_folder_iam_member" "storage_editor" {
  folder_id = local.folder_id
  role      = "storage.editor" # "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa_trr.id}"
  depends_on = [yandex_iam_service_account.sa_trr]
}


# Назначение роли сервисному аккаунту для YDB
resource "yandex_resourcemanager_folder_iam_member" "ydb_editor" {
  folder_id = local.folder_id
  role      = "ydb.editor" 
  member    = "serviceAccount:${yandex_iam_service_account.sa_trr.id}"
  depends_on = [yandex_iam_service_account.sa_trr]
}

# Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa_static_key_trr" {
  service_account_id = yandex_iam_service_account.sa_trr.id
  description        = "static access key for object storage trr"
}

# Создание бакета с использованием ключа 
resource "yandex_storage_bucket" "s3_backet_trr" {
  depends_on = [yandex_iam_service_account.sa_trr, yandex_iam_service_account_static_access_key.sa_static_key_trr]
  access_key = yandex_iam_service_account_static_access_key.sa_static_key_trr.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa_static_key_trr.secret_key
  bucket = var.bucket_name_trr
  force_destroy = true
  acl    = "private"
}
  # https://yandex.cloud/ru/docs/storage/operations/buckets/edit-acl?ysclid=m45pwms9q4822198237
  # https://yandex.cloud/ru/docs/storage/s3/api-ref/acl/xml-config
  # https://yandex.cloud/ru/docs/storage/operations/buckets/create#tf_1
  # https://yandex.cloud/ru/docs/storage/operations/buckets/edit-acl


resource "yandex_ydb_database_serverless" "db_tfstate_lock" {
  depends_on = [yandex_resourcemanager_folder_iam_member.ydb_editor]
  name                = "ydb-tfstate-lock"
  # deletion_protection = true

  serverless_database {
    enable_throttling_rcu_limit = false
    provisioned_rcu_limit       = 10
    storage_size_limit          = 1
    throttling_rcu_limit        = 0
  }
}


resource "aws_dynamodb_table" "tflock-dip" {
  depends_on = [yandex_ydb_database_serverless.db_tfstate_lock]
  name = "tflock-dip"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"  # Строковый тип данных
  }
}


# Для тестов можно положить в S3 файл.
# resource "yandex_storage_object" "cat-picture" {
#   access_key = yandex_iam_service_account_static_access_key.sa_static_key_trr.access_key
#   secret_key = yandex_iam_service_account_static_access_key.sa_static_key_trr.secret_key
#   bucket = var.bucket_name_trr
#   key    = "cat"
#   source = "./cat.jpg"
#   # acl = "public-read"
#   depends_on = [yandex_storage_bucket.s3_backet_trr]
# }

