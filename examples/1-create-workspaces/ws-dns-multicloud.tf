# This example creates one or more workspaces.

# Replace variable defaults for tfc_org.
# For each module below do the following:
# Provide values for workspace_name and tf_version.
# If VCS backed then provide value for VCS section.

#------------------------------------------------------------------------------
# Create Workspaces
#------------------------------------------------------------------------------

module "dns-multicloud" {
  source              = "../../modules/tfe"
  organization        = var.tfc_org
  workspace_name      = "dns-multicloud"
  queue_all_runs      = true
  auto_apply          = true
  tf_version          = "0.12.29"
  # VCS Section - if you don't want VCS then comment out section below.
  vcs_repo  = [
    {
      vcs_repo_identifier = "phanclan/dns-multicloud"
      working_directory   = ""
      workspace_branch    = "" # default: master
      oauth_token_id      = var.oauth_token_id
    }
  ]
}

#delete this

output "ws-dns-multicloud_id" {
  value = module.dns-multicloud.workspace_id
}

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