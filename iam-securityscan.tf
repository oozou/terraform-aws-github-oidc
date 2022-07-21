resource "aws_iam_role" "securityscan" {
  count = var.is_create_github_oidc && var.is_create_securityscan_oicd_role ? 1 : 0

  name                  = local.securityscan_role_name
  path                  = var.iam_role_path
  max_session_duration  = var.max_session_duration
  description           = "IAM Role to be assumed by github action"
  force_detach_policies = var.force_detach_policies
  permissions_boundary  = var.iam_role_permissions_boundary

  assume_role_policy = coalesce(
    try(
      data.aws_iam_policy_document.federated_assume_policy[0].json
    )
  )

  tags = merge(
    local.tags,
    { "Name" : local.securityscan_role_name }
  )


}

/* -------------------------------------------------------------------------- */
/*                             AWS_IAM_ROLE_POLICY                            */
/* -------------------------------------------------------------------------- */


/* -------------------------------------------------------------------------- */
/*                       AWS_IAM_ROLE_POLICY_ATTACHMENT                       */
/* -------------------------------------------------------------------------- */
resource "aws_iam_role_policy_attachment" "securityscan_readonly" {
  count = var.is_create_github_oidc && var.is_create_securityscan_oicd_role ? 1 : 0

  role       = aws_iam_role.securityscan[0].name
  policy_arn = var.readonly_policy_arn
}

resource "aws_iam_role_policy_attachment" "securityscan_securityaudit" {
  count = var.is_create_github_oidc && var.is_create_securityscan_oicd_role ? 1 : 0

  role       = aws_iam_role.securityscan[0].name
  policy_arn = var.securityaudit_policy_arn
}

resource "aws_iam_role_policy_attachment" "securityscan_ecr_readonly" {
  count = var.is_create_github_oidc && var.is_create_securityscan_oicd_role ? 1 : 0

  role       = aws_iam_role.securityscan[0].name
  policy_arn = var.ecr_readonly_policy_arn
}