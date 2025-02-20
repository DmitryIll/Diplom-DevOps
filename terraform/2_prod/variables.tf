variable "organization_id" {
  description = "ID of the root organization"
  type        = string
}

variable "billing_account_id" {
  description = "Billing account ID"
  type        = string
}

variable "prod_prefix" {
  description = "Name pefix for buckets, service accounts, and YDB"
  type        = string
  default     = "prod"
}

# Yandex ID of the root organization admins
variable "root_organization_admins" {
  description = "IDs of the root organization admins"
  type        = list(string)
}


variable "cloud_prod_folders" {
  type = list(map(any))
}


#  = [
#   {
#     "id" = "b1glosp1q6hkrn6f25cb"
#     "name" = "tfsate"
#   },
#   {
#     "id" = "b1glprslohpbhrlgmm4c"
#     "name" = "infra-site-prod"
#   },
# ]

variable "cloud_prod_groups" {
  type = list(map(any))
}

#  = [
#   {
#     "id" = "aje0kdpe4pef3ivd1q2i"
#     "name" = "site-prod-admin"
#   },
# ]
variable "cloud_prod_id" {
  type = string
}
variable "cloud_prod_name" {
  type = string
}

