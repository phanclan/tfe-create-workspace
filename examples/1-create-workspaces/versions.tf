provider "tfe" {
  hostname = "app.terraform.io"
}

terraform {
  required_version = ">=v0.12.29"
}

terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "pphan"

    workspaces {
      name = "1-create-workspaces"
    }
  }
}