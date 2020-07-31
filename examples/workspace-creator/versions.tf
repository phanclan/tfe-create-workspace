provider "tfe" {
  hostname = "app.terraform.io"
  version = "~> 0.20"
}

terraform {
  required_version = ">=v0.12.28"
}