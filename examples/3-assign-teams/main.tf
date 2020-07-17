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
    "${data.tfe_workspace.workspace-3.id}" = "write"
    "${data.tfe_workspace.workspace-4.id}" = "read"
  }
  team_ops = {
    "${data.tfe_workspace.workspace-1.id}" = "write"
    "${data.tfe_workspace.workspace-2.id}" = "write"
    "${data.tfe_workspace.workspace-3.id}" = "write"
    "${data.tfe_workspace.workspace-4.id}" = "write"
  }
  team_network = {
    "${data.tfe_workspace.workspace-1.id}" = "write"
    "${data.tfe_workspace.workspace-2.id}" = "write"
    "${data.tfe_workspace.workspace-3.id}" = "write"
    "${data.tfe_workspace.workspace-4.id}" = "write"
  }
  team_security = {
    "${data.tfe_workspace.workspace-1.id}" = "write"
    "${data.tfe_workspace.workspace-2.id}" = "write"
    "${data.tfe_workspace.workspace-3.id}" = "write"
    "${data.tfe_workspace.workspace-4.id}" = "write"
  }
  # team_changeme = {
  #   "${data.tfe_workspace.<workspace>.id} = "<privilege>"
  # }
}

data "tfe_workspace" "workspace-1" {
  name        = "hashicat-aws"
  organization = var.tfc_org
}

data "tfe_workspace" "workspace-2" {
  name        = "gcp-compute-instance-dev-us-west-1"
  organization = var.tfc_org
}

data "tfe_workspace" "workspace-3" {
  name        = "aws-ec2-instance-dev-us-west-1"
  organization = var.tfc_org
}

data "tfe_workspace" "workspace-4" {
  name        = "aws-ec2-instance-prod-us-west-1"
  organization = var.tfc_org
}

data "tfe_team" "team-dev" {
  name         = "dev"
  organization = var.tfc_org
}

data "tfe_team" "team-ops" {
  name         = "ops"
  organization = var.tfc_org
}

data "tfe_team" "team-network" {
  name         = "network"
  organization = var.tfc_org
}

data "tfe_team" "team-security" {
  name         = "security"
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

  depends_on   = [data.tfe_workspace.workspace-1,data.tfe_workspace.workspace-2]
}

resource "tfe_team_access" "network" {
  for_each = local.team_network
  access = each.value
  team_id      = data.tfe_team.team-network.id
  workspace_id = each.key

  depends_on   = [data.tfe_workspace.workspace-1]
}

resource "tfe_team_access" "security" {
  for_each = local.team_security
  access = each.value
  team_id      = data.tfe_team.team-security.id
  workspace_id = each.key

  # depends_on   = [module.workspace-gcp1]
}

variable "tfc_org" {
  default = "pphan"
}