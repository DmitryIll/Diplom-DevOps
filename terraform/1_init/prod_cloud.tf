module "cloud_prod" {
  # ver 1.0.1
  source = "git::https://github.com/DmitryIll/terraform-yc-cloud.git"
  # source = "git::https://github.com/terraform-yc-modules/terraform-yc-cloud.git?ref=2a8808f"

  organization_id    = var.organization_id
  billing_account_id = var.billing_account_id


  delay_after_cloud_create = "10s"

  cloud = {
    name        = "prod"
    description = "Облако для штатной работы сайта организации."
  }

  folders = [
    # {
    #   name        = "tfsate"
    #   description = "Contains TF state bucket and locks table for IAC state."
    # },
    {
      name        = "infra-site-prod"
      description = "Ifrastructure for podaction site."
    }
  ]
  groups = [
    { # Org admin - roles : organization.admin
      name        = "site-prod-admin"
      description = "site-prod admin group"
      members     = var.root_organization_admins
    },
  ]
}

# resource "yandex_billing_cloud_binding" "mycloud" {
#   billing_account_id = var.billing_account_id
#   cloud_id           = module.cloud_prod.cloud_id
# }

output "cloud_prod_id" {
  description = "ID of the cloud 'cloud-adm'"
  value       = module.cloud_prod.cloud_id
}

output "cloud_prod_name" {
  description = "Name of the cloud 'cloud-adm'"
  value       = module.cloud_prod.cloud_name
}

output "cloud_prod_folders" {
  description = "List of folders created in 'cloud-adm'"
  value       = module.cloud_prod.folders
}

output "cloud_prod_groups" {
  description = "List of groups defined in 'cloud-adm' cloud and created in parent organization"
  value       = module.cloud_prod.groups
}