# variable "tfe_token" {} # provided by root module.
variable "tf_version" {}
variable "name" { default = "pphan" }

variable "oauth_token_id" {
  description = "For VCS"
  default     = ""
}

variable "organization" {
  description = "TFE Organization"
}
variable "auto_apply" { default = false }
variable "queue_all_runs" { default = false}
variable "workspace_name" {}
variable "working_directory" { default = "" }
variable "vcs_repo" { default = [] }
# variable "vcs_repo_identifier" {}
# variable "workspace_branch" { default = ""}

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
