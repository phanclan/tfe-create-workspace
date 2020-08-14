data "tfe_workspace_ids" "create-workspaces" {
  names        = var.workspace_ids
  organization = var.tfc_org
  depends_on   = module.dns-multicloud
}

output "workspace_id" {
  value = data.tfe_workspace_ids.create-workspaces.external_ids
}

output "test" {
  value = data.tfe_workspace_ids.create-workspaces.full_names
}


#------------------------------------------------------------------------------

# Assign secrets from 4-create-variables to workspaces listed in workspace_ids.

resource "tfe_variable" "aws_access_key_id" {
  for_each = data.tfe_workspace_ids.create-workspaces.external_ids
  key = "AWS_ACCESS_KEY_ID"
  value = var.AWS_ACCESS_KEY_ID
  category = "env"
  sensitive = false
  workspace_id = each.value
}

resource "tfe_variable" "aws_secret_access_key" {
  for_each = data.tfe_workspace_ids.create-workspaces.external_ids
   key = "AWS_SECRET_ACCESS_KEY"
   value = var.AWS_SECRET_ACCESS_KEY
   category = "env"
   sensitive = true # Never Reveal this in statefiles our output
   workspace_id = each.value
}

resource "tfe_variable" "aws_session_token" {
  for_each = data.tfe_workspace_ids.create-workspaces.external_ids
   key = "AWS_SESSION_TOKEN"
   value = var.AWS_SESSION_TOKEN
   category = "env"
   sensitive = true # Never Reveal this in statefiles our output
   workspace_id = each.value
}

resource "tfe_variable" "google_credentials" {
  for_each = data.tfe_workspace_ids.create-workspaces.external_ids
   key = "GOOGLE_CREDENTIALS"
   value = var.GOOGLE_CREDENTIALS
   category = "env"
   sensitive = true # Never Reveal this in statefiles our output
   workspace_id = each.value
}