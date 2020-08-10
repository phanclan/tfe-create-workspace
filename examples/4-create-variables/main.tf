data "tfe_workspace_ids" "create-workspaces" {
  names        = var.workspace_ids
  organization = var.tfc_org
}

output "workspace_id" {
  value = data.tfe_workspace_ids[*].external_ids
}

# Assign secrets from 1-create-workspace to workspace being created.
resource "tfe_variable" "dns-multicloud-prefix" {
  # for_each = var.workspace_ids
  key = "prefix"
  value = var.prefix
  category = "terraform"
  sensitive = false # Never Reveal this in statefiles our output
  workspace_id = "pphan/dns-multicloud"
}

# resource "tfe_variable" "dns-multicloud_aws_access_key_id" {
#   # for_each = var.workspace_ids
#   key = "AWS_ACCESS_KEY_ID"
#   value = var.AWS_ACCESS_KEY_ID
#   category = "env"
#   sensitive = true # Never Reveal this in statefiles our output
#   workspace_id = module.dns-multicloud.workspace_id
# }

# resource "tfe_variable" "dns-multicloud_aws_secret_access_key" {
#    key = "AWS_SECRET_ACCESS_KEY"
#    value = var.AWS_SECRET_ACCESS_KEY
#    category = "env"
#    sensitive = true # Never Reveal this in statefiles our output
#    workspace_id = module.dns-multicloud.workspace_id
# }