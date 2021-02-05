# This example creates one or more workspaces.

# Replace variable defaults for tfc_org.
# For each module below do the following:
# Provide values for workspace_name and tf_version.
# If VCS backed then provide value for VCS section.

#------------------------------------------------------------------------------
# Create Workspaces
#------------------------------------------------------------------------------

module "workspace_2" {
  source         = "../../modules/tfe"
  organization   = var.tfc_org
  workspace_name = "gcp_compute_instance_dev_us_west_1"
  tf_version     = "0.11.14"
  vcs_repo = [
    {
      vcs_repo_identifier = "phanclan/gcp_compute_instance"
      working_directory   = ""
      workspace_branch    = "" # default: master
      oauth_token_id      = var.oauth_token_id
    }
  ]
}

module "workspace_3" {
  source         = "../../modules/tfe"
  organization   = var.tfc_org
  workspace_name = "aws_ec2_instance_dev_us_west_1"
  tf_version     = "0.12.29"
  vcs_repo = [
    {
      vcs_repo_identifier = "phanclan/aws_ec2_instance"
      working_directory   = ""
      workspace_branch    = "dev" # default: master
      oauth_token_id      = var.oauth_token_id
    }
  ]
}

module "workspace_4" {
  source         = "../../modules/tfe"
  organization   = var.tfc_org
  workspace_name = "aws_ec2_instance_prod_us_west_1"
  tf_version     = "0.12.29"
  # VCS Section - if you don't want VCS then comment out section below.
  vcs_repo = [
    {
      vcs_repo_identifier = "phanclan/aws-ec2-instance"
      working_directory   = ""
      workspace_branch    = "prod" # default: master
      oauth_token_id      = var.oauth_token_id
    }
  ]
}

output "workspace_2_id" {
  value = module.workspace_2.workspace_id
}

output "workspace_3_ids" {
  value = module.workspace_3.workspace_id
}

output "workspace_4_ids" {
  value = module.workspace_4.workspace_id
}