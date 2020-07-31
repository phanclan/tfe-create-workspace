resource "tfe_workspace" "this" {
  name              = var.workspace_name
  organization      = var.organization
  terraform_version = var.tf_version
  queue_all_runs    = var.queue_all_runs
  auto_apply        = var.auto_apply
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

resource "tfe_notification_configuration" "this" {
  name                      = "${var.workspace_name}-notification"
  enabled                   = true
  destination_type          = "email"
  # email_user_ids = [tfe_organization_membership.test.user_id]
  # triggers                  = ["run:created", "run:planning", "run:needs_attention", "run:errored"]
  triggers                  = ["run:needs_attention", "run:applying", "run:errored"]
  workspace_id     = tfe_workspace.this.id
}

resource "tfe_variable" "name" {
  key = "name"
  value = var.workspace_name
  category = "terraform"
  workspace_id = tfe_workspace.this.id
}

output "workspace_id" {
  value       = tfe_workspace.this.id
  description = "The TFE workspace ID"
}



