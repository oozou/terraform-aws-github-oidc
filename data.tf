data "tls_certificate" "github_actions_oidc_endpoint" {
  url = var.github_actions_oidc_url
}

data "aws_iam_openid_connect_provider" "github" {
  count = var.is_create_github_oidc && !var.is_create_oidc_provider ? 1 : 0

  url = var.github_actions_oidc_url
}

data "aws_iam_policy_document" "federated_assume_policy" {
  count = var.is_create_github_oidc ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type = "Federated"
      identifiers = [local.oidc_provider_arn]
    }

    condition {
      test     = "StringLike"
      variable = "${local.plain_oidc_url}:sub"

      values = [for repo in var.github_repositories : "repo:${repo}:*"]
    }
  }
}