variable "prefix" {
  description = "Terraform Organization"
  default = "pphan"
}
# variable "tfe_token" {}
# variable "oauth_token_id" {}
variable "tfc_org" {
  description = "Terraform Organization"
  default = "pphan"
}
# variable "organization" {}

# Workspace names will be used for the repo name when setting up VCS.
# If you want a workspace to start with "ADMIN" this will be removed
# from the VCS repo name we attempt to connect to.
variable "workspace_ids" {
  description = "Name of workspaces we want to modify."
  default = [
    "1-create-workspaces",
  ]
  # default = [
  #   "ADMIN-tfe-policies-example",
  #   "myapp_master",
  #   "myapp_dev",
  #   "myapp_qa",
  #   "tf-aws-ecs-fargate",
  #   "tf-google-gce-instance",
  #   "tf-azurerm-az-instance",
  #   "tf-aws-ec2-instance",
  #   "tf-aws-standard-network",
  #   "patspets_stage",
  # ]
}

# variable "cicd_workspace_ids" {
#   type = "list"

#   default = ["patspets_master"]
# }

#
### Workspace Customizations
#

# Repo working directory
# variable "working_directory" {
#   type = "map"
#   default = {
#     patspets_stage = "tfe/"
#     tf-aws-ec2-instance = "examples/simple/"
#   }
# }

# Repo Branch if different from 'master'
# variable "workspace_branch" {
#   type = "map"

#   default = {
#     myapp_qa               = "qa"
#     myapp_dev              = "dev"
#     patspets_stage         = "stage"
#   }
# }

# Team "Operations" - Access
variable "ops_access" {
  default = {
    repo   = "myapp_master,myapp_dev,myapp_qa,tf-aws-standard-network"
    access = "write,read,read,read"
  }
}

# resource "null_resource" "ops" {
#   count = "${length(split(",", var.ops_access["repo"]))}"

#   triggers {
#     repo   = "${element(split(",", var.ops_access["repo"]), count.index)}"
#     access = "${element(split(",", var.ops_access["access"]), count.index)}"
#   }
# }



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

