terraform {
  backend "s3" {
    region               = "us-east-1"
    bucket               = "terraform-tfstate-813448775391"
    key                  = "aws-config-rules-prod.tfstate"
    workspace_key_prefix = "aws-config-rules"
    dynamodb_table       = "terraform_locks"
    role_arn             = "arn:aws:iam::813448775391:role/Kubernetes-IAM-Roles-AtlantisBotAccess"
  }
}
