variable tfc_org {
    description = "Name of organization you created in Terraform Cloud."
    default = "pphan"
}
variable oauth_token_id {
    description = "Go to TFC > Organization > Settings > VCS Providers. Copy Oauth Token ID"
}
variable tfe_token {
    description = "Token to Log into TFC. Go to https://app.terraform.io/app/settings/tokens and generate a token."
}

#------------------------------------------------------------------------------

# These are pass thru secrets that we put into 1-create-workspaces.
# It allows the workspace creator to pass out secrets to workspace it creates.

variable payg_subscription_client_secret {
    description = "AKS Client Secret Key"
}
variable "GOOGLE_CREDENTIALS" {
    description = "GCP Credentials"
    default = "CHANGEME"
}
variable "AWS_ACCESS_KEY_ID" {
    description = "Grab from env vars or $HOME/.aws/credentials"
    default = "CHANGEME"
}
variable "AWS_SECRET_ACCESS_KEY" {
    description = "Grab from env vars or $HOME/.aws/credentials"
    default = "CHANGEME"
}
variable "AWS_SESSION_TOKEN" {
    description = "Grab from env vars or $HOME/.aws/credentials"
    default = "CHANGEME"
}
variable "ARM_CLIENT_ID" {
    description = "Grab from env vars or $HOME/.Azure/creds.txt"
    default = "CHANGEME"
}
variable "ARM_CLIENT_SECRET" {
    description = "Grab from env vars or $HOME/.Azure/creds.txt"
    default = "CHANGEME"
}
variable "ARM_TENANT_ID" {
    description = "Grab from env vars or $HOME/.Azure/creds.txt"
    default = "CHANGEME"
}
variable "ARM_SUBSCRIPTION_ID" {
    description = "Grab from env vars or $HOME/.Azure/creds.txt"
    default = "CHANGEME"
}