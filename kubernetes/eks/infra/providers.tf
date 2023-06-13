provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias = "downdetective"
  assume_role {
    role_arn = var.iam_role_downdetective
  }
  region = var.aws_region
}
