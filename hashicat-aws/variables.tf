variable "tfe_token" {}
variable "organization" {
  description = "TFE Organization"
  default = "pphan"
}
variable "oauth_token_id" {}
# variable "workspace_id" {
#   description="module.hashicat-aws.workspace_id or data.tfe_workspace.test.id"
#   default=data.tfe_workspace.test.id
# }