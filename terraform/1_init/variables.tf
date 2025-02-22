variable "organization_id" {
  description = "ID of the root organization"
  type        = string
}

variable "billing_account_id" {
  description = "Billing account ID"
  type        = string
}

variable "init_prefix" {
  description = "Name pefix for buckets, service accounts, and YDB"
  type        = string
  default     = "init"
}

# variable "prod_prefix" {
#   description = "Name pefix for buckets, service accounts, and YDB"
#   type        = string
#   default     = "prod"
# }

# Yandex ID of the root organization admins
variable "root_organization_admins" {
  description = "IDs of the root organization admins"
  type        = list(string)
}

variable "k8s_ver" {
  description = "Версия k8s"
  type        = string
  default     = "1.30"
}