resource tfe_workspace workspace {
    # The Name of the workspace to create in Terraform Cloud
    name = "1-create-workspaces"
    # The directory (in this repo) where the  workspace
    # starts runing. Workspace-specs is the folder
    # where we keep all of our workspaces.
    working_directory = "examples/1-create-workspaces"
    organization = var.tfc_org
    terraform_version = "0.12.29"

    # The connection to Git must be configured in
    # terraform cloud first. The oauth_token_id
    # specifies which VCS connection to use for this
    # workspace.
    vcs_repo  {
        identifier = "phanclan/tfe-create-workspace"
        oauth_token_id = var.oauth_token_id
        branch = "master"
    }
}
#
# These are needed by the workspace creator and are not
# passed down to the created workspaces
resource tfe_variable organization_name {
   key = "tfc_org"
   value = var.tfc_org
   category = "terraform"
   sensitive = false
   workspace_id = tfe_workspace.workspace.id
}
resource tfe_variable oauth_token_id {
   key = "oauth_token_id"
   value = var.oauth_token_id
   category = "terraform"
   sensitive = true
   workspace_id = tfe_workspace.workspace.id
}
resource tfe_variable tfe_token {
   key = "TFE_TOKEN"
   value = var.tfe_token
   category = "env"
   sensitive = true
   workspace_id = tfe_workspace.workspace.id
}

#------------------------------------------------------------------------------

# Add the secrets that 1-create-workspaces needs to pass to child jobs
# I'm going to show a copule of methods to pass secrets into
# the child projects.  All of these are a bit makeshift and
# have various issues, but they get you by without a secret
# keeper.

# Pass Variables Through
#
# We load these secrets into 1-create-workspaces.
# Each workspace that gets created will use these as tfvars k/v pairs.
# They are tf vars here, but env vars in the created workspaces.

resource "tfe_variable" "google_credentials" {
   key = "GOOGLE_CREDENTIALS"
   value = var.GOOGLE_CREDENTIALS
   category = "terraform"
   # Try to
   sensitive = true # Never Reveal this in statefiles our output
   workspace_id = tfe_workspace.workspace.id
}

resource "tfe_variable" "aws_access_key_id" {
   key = "AWS_ACCESS_KEY_ID"
   value = var.AWS_ACCESS_KEY_ID
   category = "terraform"
   sensitive = false # Reveal this verification
   workspace_id = tfe_workspace.workspace.id
}

resource "tfe_variable" "aws_secret_access_key" {
  key = "AWS_SECRET_ACCESS_KEY"
  value = var.AWS_SECRET_ACCESS_KEY
  category = "terraform"
  sensitive = true # Never Reveal this in statefiles our output
  workspace_id = tfe_workspace.workspace.id
}

resource "tfe_variable" "aws_session_token" {
  key = "AWS_SESSION_TOKEN"
  value = var.AWS_SESSION_TOKEN
  category = "terraform"
  sensitive = true # Never Reveal this in statefiles our output
  workspace_id = tfe_workspace.workspace.id
}
