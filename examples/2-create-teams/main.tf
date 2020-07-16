# This will create four teams: dev, ops, network, security.
# Replace locals tfc_org.
# Replace team_name per module with your own.
# Replace team_members with your own values. Keep the same format.
# Will use module for_each with 0.13 in the future.


locals {
  tfc_org = "pphan"
  prefix = "pphan"
}

#------------------------------------------------------------------------------
# Create Teams and Add Members
#------------------------------------------------------------------------------

module "team-dev" {
  source              = "../../modules/tfe_team"
  team_name = "Development"
  tfc_org = local.tfc_org
  team_members = {
    "pphan-dev" = ""
    "pphan-ops" = ""
  }
}

module "team-ops" {
  source              = "../../modules/tfe_team"
  team_name = "Operations"
  tfc_org = local.tfc_org
  team_members = {
    "pphan-ops" = ""
  }
}

module "team-network" {
  source              = "../../modules/tfe_team"
  team_name = "Network"
  tfc_org = local.tfc_org
  team_members = {
    "pphan-ops" = ""
  }
}

module "team-security" {
  source              = "../../modules/tfe_team"
  team_name = "Security"
  tfc_org = local.tfc_org
  team_members = {
    "pphan-ops" = ""
  }
}


output "team-dev-id" {
  value = module.team-dev.team_id
}
output "team-network-id" {
  value = module.team-network.team_id
}
output "team-security-id" {
  value = module.team-security.team_id
}
output "team-ops-id" {
  value = module.team-ops.team_id
}