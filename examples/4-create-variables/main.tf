# Assign secrets from 1-create-workspace to workspace being created.
resource "tfe_variable" "dns-multicloud-prefix" {
   key = "prefix"
   value = var.prefix
   category = "terraform"
   sensitive = false # Never Reveal this in statefiles our output
   workspace_id = module.dns-multicloud.workspace_id
}

resource "tfe_variable" "dns-multicloud_aws_access_key_id" {
   key = "AWS_ACCESS_KEY_ID"
   value = var.AWS_ACCESS_KEY_ID
   category = "env"
   sensitive = true # Never Reveal this in statefiles our output
   workspace_id = module.dns-multicloud.workspace_id
}

resource "tfe_variable" "dns-multicloud_aws_secret_access_key" {
   key = "AWS_SECRET_ACCESS_KEY"
   value = var.AWS_SECRET_ACCESS_KEY
   category = "env"
   sensitive = true # Never Reveal this in statefiles our output
   workspace_id = module.dns-multicloud.workspace_id
}