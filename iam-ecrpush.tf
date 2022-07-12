resource "aws_iam_role" "ecrpush" {
  count = var.is_create_github_oidc && var.is_create_ecrpush_oicd_role ? 1 : 0

  name                  = local.ecrpush_role_name
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
    { "Name" : local.ecrpush_role_name }
  )



}

/* -------------------------------------------------------------------------- */
/*                             AWS_IAM_ROLE_POLICY                            */
/* -------------------------------------------------------------------------- */


/* -------------------------------------------------------------------------- */
/*                       AWS_IAM_ROLE_POLICY_ATTACHMENT                       */
/* -------------------------------------------------------------------------- */
resource "aws_iam_role_policy_attachment" "ecr_poweruser" {
  count = var.is_create_github_oidc && var.is_create_ecrpush_oicd_role ? 1 : 0

  role       = aws_iam_role.ecrpush[0].name
  policy_arn = var.ecr_poweruser_policy_arn
}
