data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:cluster-autoscaler:cluster-autoscaler-aws-cluster-autoscaler"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}


data "aws_iam_policy_document" "cluster_autoscaler" {
  statement {
    effect = "Allow"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeLaunchTemplateVersions",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "cluster_autoscaler" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  name_prefix        = "${var.cluster_name}-cluster-autoscaler"
}

resource "aws_iam_role_policy" "cluster_autoscaler" {
  policy = data.aws_iam_policy_document.cluster_autoscaler.json
  role   = aws_iam_role.cluster_autoscaler.id
}

resource "aws_ssm_parameter" "cluster_autoscaler_role" {
  name  = "/eks/${var.cluster_name}/iamroles/cluster-autoscaler"
  type  = "String"
  value = aws_iam_role.cluster_autoscaler.arn
}

