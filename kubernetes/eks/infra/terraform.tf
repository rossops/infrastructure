terraform {
  required_version = "~> 1.3"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "downdetective-devops"
  }
}