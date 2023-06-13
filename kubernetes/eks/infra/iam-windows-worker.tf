# seperate IAM role is needed for Windows nodes,
# because the role needs different permissions in the aws-auth configmap
data "aws_iam_policy_document" "assume_ec2" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "windows_worker" {
  assume_role_policy = data.aws_iam_policy_document.assume_ec2.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
  name_prefix = "${var.cluster_name}-windows"
}
