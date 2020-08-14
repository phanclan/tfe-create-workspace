# This example creates one or more workspaces.

# Replace variable defaults for tfc_org.
# For each module below do the following:
# Provide values for workspace_name and tf_version.
# If VCS backed then provide value for VCS section.

#------------------------------------------------------------------------------
# Create Workspaces
#------------------------------------------------------------------------------

module "dns-multicloud" {
  source         = "../../modules/tfe"
  organization   = var.tfc_org
  workspace_name = "dns-multicloud"
  queue_all_runs      = true
  auto_apply = true
  tf_version = "0.12.29"
  # VCS Section - if you don't want VCS then comment out section below.
  vcs_repo = [
    {
      vcs_repo_identifier = "phanclan/dns-multicloud"
      working_directory   = ""
      workspace_branch    = "" # default: master
      oauth_token_id      = var.oauth_token_id
    }
  ]
}

data "tfe_workspace" "ws-create-workspaces" {
  name        = "1-create-workspaces"
  organization = var.tfc_org
}

resource "tfe_run_trigger" "dns-multicloud_trigger" {
  workspace_id  = module.dns-multicloud.workspace_id
  sourceable_id = data.tfe_workspace.ws-create-workspaces.id
}

output "ws-dns-multicloud_id" {
  value = module.dns-multicloud.workspace_id
}