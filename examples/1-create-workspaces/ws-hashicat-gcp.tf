module "hashicat-gcp" {
  source              = "../../modules/tfe"
  organization        = var.tfc_org
  workspace_name      = "hashicat-gcp"
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

output "ws-hashicat-gcp_ids" {
  value = module.hashicat-gcp.workspace_id
}

resource "tfe_variable" "prefix" {
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
   key = "projects"
   value = var.project
   category = "env"
   # Try to Never Reveal this in statefiles our output
   sensitive = false
   workspace_id = module.hashicat-gcp.workspace_id
}