resource "tfe_workspace" "template" {
  name              = var.workspace_name
  organization      = var.organization
  terraform_version = var.tf_version
  queue_all_runs    = false
  auto_apply        = true
  working_directory = var.working_directory

  # dynamic block allows me to not require these variables from root module.
  dynamic "vcs_repo" {
    for_each = var.vcs_repo
    content {
      oauth_token_id = vcs_repo.value.oauth_token_id
      identifier     = vcs_repo.value.vcs_repo_identifier
      branch         = vcs_repo.value.workspace_branch
    }
  }
}

output "workspace_id" {
  value       = tfe_workspace.template.id
  description = "The TFE workspace ID"
}



