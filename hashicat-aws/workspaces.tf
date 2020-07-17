module "hashicat-aws" {
  source              = "../modules/tfe"
  tfe_token           = var.tfe_token
  tfe_version         = "0.12.20" # defaults to latest if blank
  organization        = var.organization
  workspace_id        = "hashicat-aws"
  oauth_token_id      = var.oauth_token_id
  vcs_repo_identifier = "phanclan/hashicat-aws" # ex. phanclan/hashicat-aws
  working_directory   = ""
  workspace_branch    = "" # default: master
}

output "workspace_id" {
  value       = module.hashicat-aws.workspace_id
  description = "The TFE workspace ID"
}

# data "tfe_workspace" "test" {
#   name         = "hashicat-aws"
#   organization = "pphan"
# }

# output "workspace_id" {
#   value       = data.tfe_workspace.test.id
#   description = "The TFE workspace ID"
# }