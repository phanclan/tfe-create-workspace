module "workspace-5" {
  source              = "../../modules/tfe"
  organization        = var.tfc_org
  workspace_name      = "aws-ec2-instance-prod-us-west-1"
  auto_apply          = false
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

output "workspace-5_ids" {
  value = module.workspace-5.workspace_id
}

resource "tfe_variable" "prefix" {
   key = "prefix"
   value = var.prefix
   category = "terraform"
   # Try to Never Reveal this in statefiles our output
   sensitive = false
   workspace_id = module.workspace-5.workspace_id
}

resource "tfe_variable" "project" {
   key = "projects"
   value = var.project
   category = "env"
   # Try to Never Reveal this in statefiles our output
   sensitive = false
   workspace_id = module.workspace-5.workspace_id
}