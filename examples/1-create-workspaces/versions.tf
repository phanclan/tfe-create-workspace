provider "tfe" {
  # token    = var.tfe_token
  hostname = "app.terraform.io"
}

terraform {
  required_version = ">=v0.12.28"
}