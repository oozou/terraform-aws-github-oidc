<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.22.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_github_oidc"></a> [github\_oidc](#module\_github\_oidc) | ../.. | n/a |
| <a name="module_github_oidc_custom"></a> [github\_oidc\_custom](#module\_github\_oidc\_custom) | ../.. | n/a |
| <a name="module_github_oidc_ecrpush"></a> [github\_oidc\_ecrpush](#module\_github\_oidc\_ecrpush) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy_document.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account"></a> [aws\_account](#input\_aws\_account) | AWS Credentials to access AWS | <pre>object({<br>    region     = string,<br>    access_key = string,<br>    secret_key = string<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->