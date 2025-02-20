module "init" {
  # ver 1.0.1
  # source = "git::https://github.com/terraform-yc-modules/terraform-yc-cloud.git?ref=2a8808f"
  source = "git::https://github.com/DmitryIll/terraform-yc-cloud.git"

  organization_id    = var.organization_id
  billing_account_id = var.billing_account_id



  cloud = {
    name        = "init"
    description = "Cloud hosting basic resources for TF state, CICD and deploying workload clouds."
  }

  folders = [
    {
      name        = "tfsate-backend"
      description = "Contains TF state bucket and locks table for IAC state."
    }
  ]
  groups = [
    { # Org admin - roles : organization.admin
      name        = "org-admin"
      description = "Organization admin group"
      members     = var.root_organization_admins
    },
  ]
}

# ======== Assign org level roles ======= 
resource "yandex_organizationmanager_organization_iam_binding" "org_admin_for_org_admin" {
  organization_id = var.organization_id
  role            = "organization-manager.admin"
  members = [
    "group:${module.init.groups[0].id}",
  ]
}

output "init_cloud_id" {
  description = "ID of the cloud 'init'"
  value       = module.init.cloud_id
}

output "init_cloud_name" {
  description = "Name of the cloud 'init'"
  value       = module.init.cloud_name
}

output "init_cloud_folders" {
  description = "List of folders created in 'init' cloud"
  value       = module.init.folders
}

output "init_cloud_groups" {
  description = "List of groups defined in 'init' cloud and created in parent organization"
  value       = module.init.groups
}