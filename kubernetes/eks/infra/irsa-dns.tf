data "aws_iam_policy_document" "assume_role_policy_external_dns" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:external-dns:external-dns"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}


data "aws_iam_policy_document" "external_dns" {
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

resource "aws_iam_role" "external_dns" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_external_dns.json
  name_prefix        = "${var.cluster_name}-external-dns"
}

resource "aws_iam_role_policy" "external_dns" {
  policy = data.aws_iam_policy_document.external_dns.json
  role   = aws_iam_role.external_dns.id
}

resource "aws_ssm_parameter" "external_dns_role" {
  name  = "/eks/${var.cluster_name}/iamroles/external-dns"
  type  = "String"
  value = aws_iam_role.external_dns.arn
}

