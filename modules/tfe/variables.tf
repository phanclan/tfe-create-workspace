variable "tfe_token" {}
variable "tfe_version" {}

variable "oauth_token_id" {
  description = "For VCS"
}

variable "organization" {
  description = "TFE Organization"
}

variable "slackurl" {
  default = "https://hooks.slack.com/services/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"
}

variable "workspace_id" {}

variable "working_directory" {}

variable "workspace_branch" {}

# variable "repo_org" {}
# variable "gcp_region" {}
# variable "gcp_zone" {}
# variable "gcp_project" {}
# variable "gcp_credentials" {}
# variable "aws_default_region" {}
# variable "aws_secret_access_key" {}
# variable "aws_access_key_id" {}
# variable "arm_subscription_id" {}
# variable "arm_client_secret" {}
# variable "arm_tenant_id" {}
# variable "arm_client_id" {}
variable vcs_repo_identifier {}
