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
# These are only needed by the workspace creator and are not
# passed down to the individual workspaces
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


# Add the secrets that the workspace creator needs to pass to child jobs
# I'm going to show a copule of methods to pass secrets into
# the child projects.  All of these are a bit makeshift and
# have various issues, but they get you by without a secret
# keeper.

#
# Method 1: Passing Variables Through
#
# We load this secret into the master job.  Each workspace creator
# (eg: worspace-specs/ws-demo1.tf) needs to transfer
# the secrets it wants into the workspace it's creating.
#
# resource tfe_variable aks_client_secret {
#    key = "payg_subscription_client_secret"
#    value = var.payg_subscription_client_secret
#    category = "terraform"
#    # prevents the web site from showing the value.
#    sensitive = true
#    workspace_id = tfe_workspace.workspace.id
# }
resource "tfe_variable" "google_credentials" {
   key = "GOOGLE_CREDENTIALS"
   value = var.GOOGLE_CREDENTIALS
   category = "terraform"
   # Try to Never Reveal this in statefiles our output
   sensitive = true
   workspace_id = tfe_workspace.workspace.id
}

resource "tfe_variable" "aws_access_key_id" {
   key = "AWS_ACCESS_KEY_ID"
   value = var.AWS_ACCESS_KEY_ID
   category = "terraform"
   sensitive = false # Never Reveal this in statefiles our output
   workspace_id = tfe_workspace.workspace.id
}

resource "tfe_variable" "aws_secret_access_key" {
   key = "AWS_SECRET_ACCESS_KEY"
   value = var.AWS_SECRET_ACCESS_KEY
   category = "terraform"
   sensitive = true # Never Reveal this in statefiles our output
   workspace_id = tfe_workspace.workspace.id
}

#
# Method 2: Passing blobs of secrets around
#
# This method loads a file of secrets which the workspace creator passes
# to the workspace being created in bulk. The downside is that you could
# be passing secrets to jobs that don't need all of them, increasing
# your attack surface
# resource tfe_variable testvalues {
#    key = "secret_bundle_1"
#    hcl = false
#    value = file("secret_bundle_1.hcl")
#    category = "terraform"
#    sensitive = true
#    workspace_id = tfe_workspace.workspace.id
# }

