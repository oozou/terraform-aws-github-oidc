output "custom_iam_role_arn" {
  depends_on  = [aws_iam_role.custom]
  description = "ARN of the IAM role."
  value       = var.is_create_github_oidc && var.is_create_custom_oicd_role ? aws_iam_role.custom[0].arn : ""
}

output "securityscan_iam_role_arn" {
  depends_on  = [aws_iam_role.securityscan]
  description = "ARN of the IAM role."
  value       = var.is_create_github_oidc && var.is_create_securityscan_oicd_role ? aws_iam_role.securityscan[0].arn : ""
}

output "ecrpush_iam_role_arn" {
  depends_on  = [aws_iam_role.ecrpush]
  description = "ARN of the IAM role."
  value       = var.is_create_github_oidc && var.is_create_ecrpush_oicd_role ? aws_iam_role.ecrpush[0].arn : ""
}

output "aws_iam_openid_connect_provider_arn" {
  depends_on  = [aws_iam_openid_connect_provider.this]
  description = "ARN of the Github oidc provider."
  value       = var.is_create_github_oidc && var.is_create_oidc_provider ? aws_iam_openid_connect_provider.this[0].arn : ""
}
