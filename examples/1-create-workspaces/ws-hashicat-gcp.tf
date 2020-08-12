# This example creates one or more workspaces.

# Replace variable defaults for tfc_org.
# For each module below do the following:
# Provide values for workspace_name and tf_version.
# If VCS backed then provide value for VCS section.

#------------------------------------------------------------------------------
# Create Workspaces
#------------------------------------------------------------------------------

variable "create_hashicat-gcp" {
  description = "Set to true if you want to create this workspace."
  type        = bool
  default     = "false"
}

module "hashicat-gcp" {
  count               = var.create_hashicat-gcp ? 1 : 0
  source              = "../../modules/tfe"
  organization        = var.tfc_org
  workspace_name      = "hashicat-gcp"
  # auto_apply          = true
  tf_version          = "0.12.29"
  # VCS Section - if you don't want VCS then comment out section below.
  vcs_repo  = [
    {
      vcs_repo_identifier = "phanclan/hashicat-gcp"
      working_directory   = ""
      workspace_branch    = "" # default: master
      oauth_token_id      = var.oauth_token_id
    }
  ]
}

output "ws-hashicat-gcp_ids" {
  value = module.hashicat-gcp.workspace_id
}

resource "tfe_variable" "prefix" {
  count               = var.create_hashicat-gcp ? 1 : 0
  key = "prefix"
  value = var.prefix
  category = "terraform"
  # Try to Never Reveal this in statefiles our output
  sensitive = false
  workspace_id = module.hashicat-gcp.workspace_id
}

# Pass down the secrets from 1-create-workspace to
# the job being created.
resource "tfe_variable" "project" {
  count               = var.create_hashicat-gcp ? 1 : 0
   key = "project"
   value = var.project
   category = "terraform"
   sensitive = false # Never Reveal this in statefiles our output
   workspace_id = module.hashicat-gcp.workspace_id
}

# resource "tfe_variable" "google_credentials" {
#    key = "GOOGLE_CREDENTIALS"
#    value = var.GOOGLE_CREDENTIALS
#    category = "env"
#    sensitive = true # Never Reveal this in statefiles our output
#    workspace_id = module.hashicat-gcp.workspace_id
# }