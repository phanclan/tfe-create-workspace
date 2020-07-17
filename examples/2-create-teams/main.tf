# This will create four teams: dev, ops, network, security.
# Replace locals tfc_org.
# Replace team_name per module with your own.
# Replace team_members with your own values. Keep the same format.
# Will use module for_each with 0.13 in the future.


locals {
  prefix = "pphan"
}

#------------------------------------------------------------------------------
# Create Teams and Add Members
#------------------------------------------------------------------------------

module "team-dev" {
  source              = "../../modules/tfe_team"
  team_name = "dev"
  tfc_org = var.tfc_org
  team_members = {
    "pphan-dev" = ""
    "pphan-ops" = ""
  }
}

module "team-ops" {
  source              = "../../modules/tfe_team"
  team_name = "ops"
  tfc_org = var.tfc_org
  team_members = {
    "pphan-ops" = ""
  }
}

module "team-network" {
  source              = "../../modules/tfe_team"
  team_name = "network"
  tfc_org = var.tfc_org
  team_members = {
    "pphan-ops" = ""
  }
}

module "team-security" {
  source              = "../../modules/tfe_team"
  team_name = "security"
  tfc_org = var.tfc_org
  team_members = {
    "pphan-ops" = ""
  }
}

# module "team-changeme" {
#   source              = "../../modules/tfe_team"
#   team_name = "Changeme"
#   tfc_org = var.tfc_org
#   team_members = {
#     "pphan-ops" = ""
#   }
# }


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

# output "team-changeme-id" {
#   value = module.team-changeme.team_id
# }

variable "tfc_org" {
  default = "pphan"
}