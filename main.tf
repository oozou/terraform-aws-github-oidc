resource "aws_iam_openid_connect_provider" "this" {
  count = var.is_create_github_oidc && var.is_create_oidc_provider ? 1 : 0

  client_id_list = concat(
    ["sts.amazonaws.com"]
  )

  tags = merge(
    local.tags
  )

  thumbprint_list = [
    local.thumbprint
  ]
  url = var.github_actions_oidc_url
}





resource "aws_iam_role" "custom" {
  count = var.is_create_github_oidc && var.is_create_custom_oicd_role ? 1 : 0

  name                  = local.custom_role_name
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
    { "Name" : local.custom_role_name }
  )

  dynamic "inline_policy" {
    for_each = var.custom_iam_role_inline_policies

    content {
      name   = inline_policy.key
      policy = inline_policy.value
    }
  }
}

resource "aws_iam_role_policy_attachment" "custom" {
  count      = var.is_create_github_oidc && var.is_create_custom_oicd_role ? "${length(var.custom_role_iam_policy_arns)}":0
  role       = aws_iam_role.custom[0].name
  policy_arn = "${var.custom_role_iam_policy_arns[count.index]}"
}