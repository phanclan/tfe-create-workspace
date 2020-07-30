# This example creates one or more workspaces.

# Replace variable defaults for tfc_org.
# For each module below do the following:
# Provide values for workspace_name and tf_version.
# If VCS backed then provide value for VCS section.

#------------------------------------------------------------------------------
# Create Workspaces
#------------------------------------------------------------------------------

module "workspace-2" {
  source              = "../../modules/tfe"
  organization        = var.tfc_org
  workspace_name      = "gcp-compute-instance-dev-us-west-1"
  tf_version          = "0.11.14"
  vcs_repo = [
    {
      vcs_repo_identifier = "phanclan/gcp-compute-instance"
      working_directory   = ""
      workspace_branch    = "" # default: master
      oauth_token_id      = var.oauth_token_id
    }
  ]
}

module "workspace-3" {
  source              = "../../modules/tfe"
  organization        = var.tfc_org
  workspace_name      = "aws-ec2-instance-dev-us-west-1"
  tf_version          = "0.12.29"
  vcs_repo = [
    {
      vcs_repo_identifier = "phanclan/aws-ec2-instance"
      working_directory   = ""
      workspace_branch    = "dev" # default: master
      oauth_token_id      = var.oauth_token_id
    }
  ]
}

module "workspace-4" {
  source              = "../../modules/tfe"
  organization        = var.tfc_org
  workspace_name      = "aws-ec2-instance-prod-us-west-1"
  auto_apply          = false
  tf_version          = "0.12.29"
  # VCS Section - if you don't want VCS then comment out section below.
  vcs_repo  = [
    {
      vcs_repo_identifier = "phanclan/aws-ec2-instance"
      working_directory   = ""
      workspace_branch    = "prod" # default: master
      oauth_token_id      = var.oauth_token_id
    }
  ]
}

output "workspace-2_id" {
  value = module.workspace-2.workspace_id
}

output "workspace-3_ids" {
  value = module.workspace-3.workspace_id
}

output "workspace-4_ids" {
  value = module.workspace-4.workspace_id
}

#comment