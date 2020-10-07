# provider "tfe" {
#   hostname = "app.terraform.io"
# }

terraform {
  required_version = ">=v0.12.29"
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.22.0"
    }
  }
}