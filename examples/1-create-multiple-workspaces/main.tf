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
  workspace_name      = "gcp-compute-instance-dev-us-west-1"
  tf_version          = "0.11.14"
  # VCS Section
  vcs_repo_identifier = "phanclan/gcp-compute-instance"
  working_directory   = ""
  workspace_branch    = "" # default: master
  oauth_token_id      = var.oauth_token_id
}

output "workspace_ids" {
  value = module.workspace-1.workspace_id
}

variable "tfc_org" {
  default = "pphan"
}
variable "oauth_token_id" {}