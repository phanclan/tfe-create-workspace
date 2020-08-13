variable tfc_org {
    description = "Name of organization you created in Terraform Cloud."
    default = "pphan"
}
variable oauth_token_id {
    description = "Go to TFC site-> Organization-> Settings-> VCS Providers. Copy the Oauth Token ID"
}
variable tfe_token {
    description = "Token to Log into TFC. Go to https://app.terraform.io/app/settings/tokens and generate a token."
}

#
# These are demonstration secrets that we put into the Job Creator Job
# It allows the job creator to pass out secrets to jobs it creates.
#
variable payg_subscription_client_secret {
    description = "AKS Client Secret Key"
}
variable "GOOGLE_CREDENTIALS" { default = "CHANGEME" }
variable "AWS_ACCESS_KEY_ID" { default = "CHANGEME"}
variable "AWS_SECRET_ACCESS_KEY" { default = "CHANGEME"}
variable "AWS_SESSION_TOKEN" { default = "CHANGEME"}