/* -------------------------------------------------------------------------- */
/*                                   LOCALS                                   */
/* -------------------------------------------------------------------------- */
locals {

  securityscan_role_name = format("%s-%s-%s-%s", var.prefix, upper(var.environment), var.securityscan_role_name_prefix, var.role_name_suffix)
  ecrpush_role_name = format("%s-%s-%s-%s", var.prefix, upper(var.environment), var.ecrpush_role_name_prefix, var.role_name_suffix)
  ecs_role_name = format("%s-%s-%s-%s", var.prefix, upper(var.environment), var.ecs_role_name_prefix, var.role_name_suffix)
  custom_role_name  =  format("%s-%s-%s-%s", var.prefix, upper(var.environment), var.custom_role_name_prefix, var.role_name_suffix)
  
  github_organizations = [for repo in var.github_repositories : split("/", repo)[0]]
  oidc_provider_arn    = var.is_create_github_oidc ? (var.is_create_oidc_provider ? aws_iam_openid_connect_provider.this[0].arn : data.aws_iam_openid_connect_provider.github[0].arn) : ""
  thumbprint        = data.tls_certificate.github_actions_oidc_endpoint.certificates.0.sha1_fingerprint
  plain_oidc_url    = trimprefix(var.github_actions_oidc_url, "https://")

  tags = merge(
    {
      Terraform   = true
      Environment = var.environment
    },
    var.tags
  )
}