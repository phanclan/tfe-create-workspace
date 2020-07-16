# This will assign the four teams from step 2: dev, ops, network, security.
# Replace variable tfc_org.
# Add team_xxx = {} for each team you want to assign to workspace.
  # Need to provide team_id and privileges.
# Need a data.tfe_workspace resource for each workspace you want to add teams to.
# Replace team_members with your own values. Keep the same format.
# Will use module for_each with 0.13 in the future.

locals {
  team_dev = {
    "${data.tfe_workspace.workspace-1.id}" = "read"
    "${data.tfe_workspace.workspace-2.id}" = "read"
    # "${data.tfe_workspace.workspace-3.id}" = "write"
  }
  team_ops = {
    "${data.tfe_workspace.workspace-1.id}" = "write"
    "${data.tfe_workspace.workspace-2.id}" = "write"
    "${data.tfe_workspace.workspace-3.id}" = "write"
  }
  team_security = {
    "${data.tfe_workspace.workspace-1.id}" = "write"
    "${data.tfe_workspace.workspace-2.id}" = "write"
    "${data.tfe_workspace.workspace-3.id}" = "write"
  }
  # team_xxx = {
  #   "${data.tfe_workspace.<workspace>.id} = "<privilege>"
  # }
}

data "tfe_workspace" "workspace-1" {
  name        = "gcp-compute-instance-dev-us-west-1"
  organization = var.tfc_org
}

data "tfe_workspace" "workspace-2" {
  name        = "aws-ec2-instance-dev-us-west-1"
  organization = var.tfc_org
}

data "tfe_workspace" "workspace-3" {
  name        = "aws-ec2-instance-prod-us-west-1"
  organization = var.tfc_org
}

data "tfe_team" "team-dev" {
  name         = "Development"
  organization = var.tfc_org
}

data "tfe_team" "team-ops" {
  name         = "Operations"
  organization = var.tfc_org
}

#------------------------------------------------------------------------------
# Provide Team Access to Workspaces
#------------------------------------------------------------------------------

resource "tfe_team_access" "dev" {
  for_each = local.team_dev
  access = each.value
  team_id      = data.tfe_team.team-dev.id
  workspace_id = each.key

  depends_on   = [data.tfe_workspace.workspace-1]
}

resource "tfe_team_access" "ops" {
  for_each = local.team_ops
  access = each.value
  team_id      = data.tfe_team.team-ops.id
  workspace_id = each.key

  # depends_on   = [module.workspace-gcp1]
}

variable "tfc_org" {
  default = "pphan"
}