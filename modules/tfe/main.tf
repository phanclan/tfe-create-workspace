provider "tfe" {
  token    = var.tfe_token
  hostname = "app.terraform.io"
}

# data "tfe_workspace" "one-webserver" {
#   name         = "staging-one-webserver-aws-usw2"
#   organization = "pphan"
# }

resource "tfe_workspace" "template" {
  name              = var.workspace_id
  organization      = var.organization
  terraform_version = var.tfe_version
  queue_all_runs    = false
  auto_apply        = true
  working_directory = var.working_directory

  vcs_repo {
    oauth_token_id = var.oauth_token_id
    identifier     = var.vcs_repo_identifier
    branch         = var.workspace_branch
  }
}

#------------------------------------------------------------------------------
# WORKSPACE VARIABLES
#------------------------------------------------------------------------------
# resource "tfe_variable" "vcs_repo_identifier" {
#   key          = "vcs_repo_identifier"
#   value        = "${var.vcs_repo_identifier}"
#   category     = "terraform"
#   workspace_id = "${tfe_workspace.producer.id}"
# }

output "workspace_id" {
  value       = tfe_workspace.template.id
  description = "The TFE workspace ID"
}



