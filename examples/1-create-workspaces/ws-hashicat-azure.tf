# This example creates one or more workspaces.

# Replace variable defaults for tfc_org.
# For each module below do the following:
# Provide values for workspace_name and tf_version.
# If VCS backed then provide value for VCS section.

#------------------------------------------------------------------------------
# Create Workspaces
#------------------------------------------------------------------------------

module "hashicat-azure" {
  source         = "../../modules/tfe"
  organization   = var.tfc_org
  workspace_name = "hashicat-azure"
  queue_all_runs = false
  auto_apply     = true
  tf_version     = "0.12.29"
  # VCS Section - if you don't want VCS then comment out section below.
  vcs_repo = [
    {
      vcs_repo_identifier = "phanclan/hashicat-azure"
      working_directory   = ""
      workspace_branch    = "" # default: master
      oauth_token_id      = var.oauth_token_id
    }
  ]
}

resource "tfe_run_trigger" "hashicat-azure_trigger" {
  workspace_id  = module.hashicat-azure.workspace_id
  sourceable_id = module.dns-multicloud.workspace_id
}

output "ws-hashicat-azure_id" {
  value = module.hashicat-azure.workspace_id
}

# Assign secrets from 1-create-workspace to workspace being created.
resource "tfe_variable" "hashicat-azure-prefix" {
  key          = "prefix"
  value        = var.prefix
  category     = "terraform"
  sensitive    = false # Never Reveal this in statefiles or output
  workspace_id = module.hashicat-azure.workspace_id
}