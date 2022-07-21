
# terraform-aws-github-oidc

  

# Purpose

Terraform module to create a GitHub OIDC provider and the associated IAM roles. This enables GitHub Actions to access resources within an AWS account without requiring long-lived credentials to be stored as GitHub secrets.

  

# Features

 - Create an AWS OIDC provider for GitHub Actions

 - Create one or more IAM role that can be assumed by GitHub Actions include buildin and custom roles:
	  - AWS security scan role (build in)
	  - AWS ECR publisher role (build in)
	  - Custom role

 - IAM roles can be scoped to :
	 - One or more GitHub repository

  

## Usage

```terraform

module "github_oidc_buildinRole" {
  source = "source = "git@github.com:oozou/terraform-aws-github-oidc.git?ref=<ref_id>"
  github_repositories=["oozou/terraform-aws-test1","oozou/terraform-aws-test2"]
  is_create_securityscan_oicd_role=true
  is_create_ecrpush_oicd_role=true
  environment = "dev"
  prefix = "oozou-sandbox"
  
}

module "github_oidc_custom" {
  depends_on = [module.github_oidc_buildinRole]
  source = "source = "git@github.com:oozou/terraform-aws-github-oidc.git?ref=<ref_id>"
  custom_role_name_prefix="S3_ReadOnly"
  github_repositories=["oozou/terraform-aws-xxx"]
  is_create_custom_oicd_role=true
  is_create_oidc_provider=false
  custom_role_iam_policy_arns=["arn:aws:iam::aws:policy/ReadOnlyAccess"]
  custom_iam_role_inline_policies = {
    "example_inline_policy" : data.aws_iam_policy_document.example.json
  }
  environment = "dev"
  prefix = "oozou-sandbox"
  
}

data "aws_iam_policy_document" "example" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["*"]
  }
}

```

  

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 3.4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | ~> 3.4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ecrpush](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.securityscan](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecr_poweruser](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.securityscan_ecr_readonly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.securityscan_readonly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.securityscan_securityaudit](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_openid_connect_provider.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_openid_connect_provider) | data source |
| [aws_iam_policy_document.federated_assume_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [tls_certificate.github_actions_oidc_endpoint](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_iam_role_inline_policies"></a> [custom\_iam\_role\_inline\_policies](#input\_custom\_iam\_role\_inline\_policies) | Inline policies map with policy name as key and json as value. | `map(string)` | `{}` | no |
| <a name="input_custom_role_iam_policy_arns"></a> [custom\_role\_iam\_policy\_arns](#input\_custom\_role\_iam\_policy\_arns) | AWS built in policies for custom role | `list(string)` | `[]` | no |
| <a name="input_custom_role_name_prefix"></a> [custom\_role\_name\_prefix](#input\_custom\_role\_name\_prefix) | IAM role name to be <role\_name>-GithubOIDCRole | `string` | `"custom"` | no |
| <a name="input_ecr_poweruser_policy_arn"></a> [ecr\_poweruser\_policy\_arn](#input\_ecr\_poweruser\_policy\_arn) | AWS built in ECR PowerUser access policy arn | `string` | `"arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"` | no |
| <a name="input_ecr_readonly_policy_arn"></a> [ecr\_readonly\_policy\_arn](#input\_ecr\_readonly\_policy\_arn) | AWS built in ECR readonly access policy arn | `string` | `"arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"` | no |
| <a name="input_ecrpush_role_name_prefix"></a> [ecrpush\_role\_name\_prefix](#input\_ecrpush\_role\_name\_prefix) | IAM role name to be <role\_name>-GithubOIDCRole | `string` | `"ECR_ReadWrite"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment Variable used as a prefix | `string` | n/a | yes |
| <a name="input_force_detach_policies"></a> [force\_detach\_policies](#input\_force\_detach\_policies) | Flag to force detachment of policies attached to the IAM role. | `string` | `false` | no |
| <a name="input_github_actions_oidc_url"></a> [github\_actions\_oidc\_url](#input\_github\_actions\_oidc\_url) | The URL to use for the OIDC handshake | `string` | `"https://token.actions.githubusercontent.com"` | no |
| <a name="input_github_repositories"></a> [github\_repositories](#input\_github\_repositories) | List of GitHub organization/repository names authorized to assume the role. | `list(string)` | n/a | yes |
| <a name="input_github_thumbprint"></a> [github\_thumbprint](#input\_github\_thumbprint) | GitHub OpenID TLS certificate thumbprint. | `string` | `"6938fd4d98bab03faadb97b34396831e3780aea1"` | no |
| <a name="input_iam_role_path"></a> [iam\_role\_path](#input\_iam\_role\_path) | Path under which to create IAM role. | `string` | `"/"` | no |
| <a name="input_iam_role_permissions_boundary"></a> [iam\_role\_permissions\_boundary](#input\_iam\_role\_permissions\_boundary) | ARN of the permissions boundary to be used by the IAM role. | `string` | `""` | no |
| <a name="input_is_create_custom_oicd_role"></a> [is\_create\_custom\_oicd\_role](#input\_is\_create\_custom\_oicd\_role) | Whether to create custom oidc role | `bool` | `false` | no |
| <a name="input_is_create_ecrpush_oicd_role"></a> [is\_create\_ecrpush\_oicd\_role](#input\_is\_create\_ecrpush\_oicd\_role) | Whether to create ecr readwrite oidc role | `bool` | `false` | no |
| <a name="input_is_create_github_oidc"></a> [is\_create\_github\_oidc](#input\_is\_create\_github\_oidc) | Flag to enable/disable the creation of GitHub OIDC resources. | `bool` | `true` | no |
| <a name="input_is_create_oidc_provider"></a> [is\_create\_oidc\_provider](#input\_is\_create\_oidc\_provider) | Flag to enable/disable the creation of the GitHub OIDC provider. | `bool` | `true` | no |
| <a name="input_is_create_securityscan_oicd_role"></a> [is\_create\_securityscan\_oicd\_role](#input\_is\_create\_securityscan\_oicd\_role) | Whether to create securityscan oidc role | `bool` | `false` | no |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | Maximum session duration in seconds. | `number` | `3600` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix name of customer to be displayed in AWS console and resource | `string` | n/a | yes |
| <a name="input_readonly_policy_arn"></a> [readonly\_policy\_arn](#input\_readonly\_policy\_arn) | AWS built in readonly access policy arn | `string` | `"arn:aws:iam::aws:policy/ReadOnlyAccess"` | no |
| <a name="input_role_name_suffix"></a> [role\_name\_suffix](#input\_role\_name\_suffix) | IAM role name to be <role\_name><role\_name\_suffix> | `string` | `"GithubOIDCRole"` | no |
| <a name="input_securityaudit_policy_arn"></a> [securityaudit\_policy\_arn](#input\_securityaudit\_policy\_arn) | AWS built in securityaudit access policy arn | `string` | `"arn:aws:iam::aws:policy/SecurityAudit"` | no |
| <a name="input_securityscan_role_name_prefix"></a> [securityscan\_role\_name\_prefix](#input\_securityscan\_role\_name\_prefix) | IAM role name to be <role\_name>-GithubOIDCRole | `string` | `"SecurityScan"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Custom tags which can be passed on to the AWS resources. They should be key value pairs having distinct keys | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_iam_openid_connect_provider_arn"></a> [aws\_iam\_openid\_connect\_provider\_arn](#output\_aws\_iam\_openid\_connect\_provider\_arn) | ARN of the Github oidc provider. |
| <a name="output_custom_iam_role_arn"></a> [custom\_iam\_role\_arn](#output\_custom\_iam\_role\_arn) | ARN of the IAM role. |
| <a name="output_ecrpush_iam_role_arn"></a> [ecrpush\_iam\_role\_arn](#output\_ecrpush\_iam\_role\_arn) | ARN of the IAM role. |
| <a name="output_securityscan_iam_role_arn"></a> [securityscan\_iam\_role\_arn](#output\_securityscan\_iam\_role\_arn) | ARN of the IAM role. |
<!-- END_TF_DOCS -->