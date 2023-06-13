# creates IAM Role, that can be assumed by another account, for managing route53 resources
data "aws_iam_policy_document" "assume_role_policy_external_dns_dd_assume" {
  count = var.dns_dd ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
  }
}

data "aws_iam_policy_document" "external_dns_dd_assume" {
  count = var.dns_dd ? 1 : 0

  statement {
    effect = "Allow"

    actions = [
      "route53:ChangeResourceRecordSets"
    ]

    resources = ["arn:aws:route53:::hostedzone/*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "external_dns_dd_assume" {
  count    = var.dns_dd ? 1 : 0
  provider = aws.downdetective

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_external_dns_dd_assume[0].json
  name_prefix        = "${var.cluster_name}-external-dns-dd-assume"
}

resource "aws_iam_role_policy" "external_dns_dd_assume" {
  count    = var.dns_dd ? 1 : 0
  provider = aws.downdetective

  policy = data.aws_iam_policy_document.external_dns_dd_assume[0].json
  role   = aws_iam_role.external_dns_dd_assume[0].id
}

resource "aws_ssm_parameter" "external_dns_role_ss_assume" {
  count = var.dns_dd ? 1 : 0

  name  = "/eks/${var.cluster_name}/iamroles/external-dns-dd-assume"
  type  = "String"
  value = aws_iam_role.external_dns_dd_assume[0].arn
}


# creates IAM Role in the EKS cluster account that can assume the role created above
data "aws_iam_policy_document" "assume_role_policy_external_dns_dd" {
  count = var.dns_dd ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:external-dns:external-dns-dd"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

data "aws_iam_policy_document" "external_dns_dd" {
  count = var.dns_dd ? 1 : 0

  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    resources = [aws_iam_role.external_dns_dd_assume[0].arn]
  }
}

resource "aws_iam_role" "external_dns_dd" {
  count = var.dns_dd ? 1 : 0

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_external_dns_dd[0].json
  name_prefix        = "${var.cluster_name}-external-dns-dd"
}

resource "aws_iam_role_policy" "external_dns_dd" {
  count = var.dns_dd ? 1 : 0

  policy = data.aws_iam_policy_document.external_dns_dd[0].json
  role   = aws_iam_role.external_dns_dd[0].id
}

resource "aws_ssm_parameter" "external_dns_role_dd" {
  count = var.dns_dd ? 1 : 0

  name  = "/eks/${var.cluster_name}/iamroles/external-dns-dd"
  type  = "String"
  value = aws_iam_role.external_dns_dd[0].arn
}

