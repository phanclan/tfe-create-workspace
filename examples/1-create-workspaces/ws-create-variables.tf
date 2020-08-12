# This example creates one or more workspaces.

# Replace variable defaults for tfc_org.
# For each module below do the following:
# Provide values for workspace_name and tf_version.
# If VCS backed then provide value for VCS section.

#------------------------------------------------------------------------------
# Create Workspaces
#------------------------------------------------------------------------------

module "create-variables" {
  source            = "../../modules/tfe"
  organization      = var.tfc_org
  workspace_name    = "4-create-variables"
  working_directory = "examples/4-create-variables"
  queue_all_runs    = true
  auto_apply        = true
  tf_version        = "0.12.29"
  # VCS Section - if you don't want VCS then comment out section below.
  vcs_repo = [
    {
      vcs_repo_identifier = "phanclan/tfe-create-workspace"
      workspace_branch    = "" # default: master
      oauth_token_id      = var.oauth_token_id
    }
  ]
}

#delete this

output "ws-4-create-variables_id" {
  value = module.create-variables.workspace_id
}

# Assign secrets from 1-create-workspace to workspace being created.
# resource "tfe_variable" "hashicat-aws-prefix" {
#    key = "prefix"
#    value = var.prefix
#    category = "terraform"
#    sensitive = false # Never Reveal this in statefiles or output
#    workspace_id = module.hashicat-aws.workspace_id
# }

# resource "tfe_variable" "hashicat-aws_aws_access_key_id" {
#    key = "AWS_ACCESS_KEY_ID"
#    value = var.AWS_ACCESS_KEY_ID
#    category = "env"
#    sensitive = true # Never Reveal this in statefiles or output
#    workspace_id = module.hashicat-aws.workspace_id
# }

# resource "tfe_variable" "hashicat-aws_aws_secret_access_key" {
#    key = "AWS_SECRET_ACCESS_KEY"
#    value = var.AWS_SECRET_ACCESS_KEY
#    category = "env"
#    sensitive = true # Never Reveal this in statefiles or output
#    workspace_id = module.hashicat-aws.workspace_id
# }

# resource "tfe_variable" "hashicat-aws_aws_session_token_variable" {
#   key = "AWS_SESSION_TOKEN"
#   value = var.AWS_SESSION_TOKEN
#   category = "env"
#   sensitive = true # Never Reveal this in statefiles or output
#   workspace_id = module.hashicat-aws.workspace_id
# }