# EKS Terraform

Creates an eks cluster, managed node groups, IAM Roles for Service Accounts, and cluster access via IAM Roles.
Uses the public Terraform EKS module: <https://github.com/terraform-aws-modules/terraform-aws-eks>

Workspaces can be found in TF Cloud named `eks-*`

## Windows Nodes

The EKS Terraform module does not properly set the required `aws-auth` configmap permissions for Windows nodes.
We use the `aws_auth_node_iam_role_arns_windows` and `iam_role_arn` parameters to get around this problem.

## Useful Reading

- <https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html>
- <https://docs.aws.amazon.com/eks/latest/userguide/eks-add-ons.html>
- <https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html>
- <https://docs.aws.amazon.com/eks/latest/userguide/eks-linux-ami-versions.html>
- <https://docs.aws.amazon.com/eks/latest/userguide/eks-ami-versions-windows.html>
