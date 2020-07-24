# This example creates one or more workspaces.

# Replace variable defaults for tfc_org.
# For each module below do the following:
# Provide values for workspace_name and tf_version.
# If VCS backed then provide value for VCS section.

#------------------------------------------------------------------------------
# Create Workspaces
#------------------------------------------------------------------------------

module "workspace-1" {
  source              = "../../modules/tfe"
  organization        = var.tfc_org
  workspace_name      = "hashicat-aws"
  tf_version          = "0.12.29"
  # VCS Section - if you don't want VCS then comment out section below.
  # vcs_repo  = [
  #   {
  #     vcs_repo_identifier = "phanclan/hashicat-aws"
  #     working_directory   = ""
  #     workspace_branch    = "" # default: master
  #     oauth_token_id      = var.oauth_token_id
  #   }
  # ]
}

output "workspace-1_id" {
  value = module.workspace-1.workspace_id
}
