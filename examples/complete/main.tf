module "github_oidc_securityscan" {
  source = "../.."
  github_repositories=["oozou/terraform-aws-blueprint-guideline","oozou/terraform-aws-github-oidc"]
  is_create_securityscan_oicd_role=true
  is_create_oidc_provider=true
  environment = "dev"
  prefix = "oozou-sandbox"
  
}

module "github_oidc_ecrpush" {
  depends_on = [module.github_oidc_securityscan]
  source = "../.."
  github_repositories=["oozou/terraform-aws-github-oidc"]
  is_create_ecrpush_oicd_role=true
  is_create_oidc_provider=false
  environment = "dev"
  prefix = "oozou-sandbox"
  
}

module "github_oidc_custom" {
  depends_on = [module.github_oidc_securityscan]
  source = "../.."
  custom_role_name_prefix="Admin"
  github_repositories=["oozou/terraform-aws-blueprint-guideline"]
  is_create_custom_oicd_role=true
  is_create_oidc_provider=false
  custom_role_iam_policy_arns=["arn:aws:iam::aws:policy/AdministratorAccess"]
  environment = "dev"
  prefix = "oozou-sandbox"
  
}

data "aws_iam_policy_document" "example" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["*"]
  }
}
