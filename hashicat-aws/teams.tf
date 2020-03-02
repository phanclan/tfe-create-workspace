#------------------------------------------------------------------------------
# CREATE TEAMS
#------------------------------------------------------------------------------

resource "tfe_team" "ops" {
  name         = "hashicat-ops"
  organization = var.organization
}

resource "tfe_team" "dev" {
  name         = "hashicat-dev"
  organization = var.organization
}

#------------------------------------------------------------------------------
# ADD MEMBERS TO TEAMS
#------------------------------------------------------------------------------

resource "tfe_team_member" "ops" {
  team_id  = tfe_team.ops.id
  username = "pphan-ops"
}

resource "tfe_team_member" "dev" {
  team_id  = tfe_team.dev.id
  username = "pphan-dev"
}

#------------------------------------------------------------------------------
# ADD ACCESS TO TEAMS
#------------------------------------------------------------------------------

resource "tfe_team_access" "ops" {
  access       = "admin"
  team_id      = tfe_team.ops.id
  workspace_id = module.hashicat-aws.workspace_id
}

resource "tfe_team_access" "dev" {
  access       = "read"
  team_id      = tfe_team.dev.id
  workspace_id = module.hashicat-aws.workspace_id
}

output "ops_team_id" {
  value       = tfe_team.ops.id
  description = "The TFE Ops team ID"
}

output "dev_team_id" {
  value       = tfe_team.dev.id
  description = "The TFE Dev team ID"
}