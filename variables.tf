/* -------------------------------------------------------------------------- */
/*                                   Generic                                  */
/* -------------------------------------------------------------------------- */

variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
}

variable "prefix" {
  description = "The prefix name of customer to be displayed in AWS console and resource"
  type        = string
}

variable "tags" {
  description = "Custom tags which can be passed on to the AWS resources. They should be key value pairs having distinct keys"
  type        = map(any)
  default     = {}
}

/* -------------------------------------------------------------------------- */
/*                                     GitHub OIDC                            */
/* -------------------------------------------------------------------------- */

variable "is_create_github_oidc" {
  type        = bool
  description = "Flag to enable/disable the creation of GitHub OIDC resources."
  default     = true
}

variable "is_create_oidc_provider" {
  default     = true
  description = "Flag to enable/disable the creation of the GitHub OIDC provider."
  type        = bool
}


variable "github_actions_oidc_url" {
  type        = string
  description = "The URL to use for the OIDC handshake"
  default     = "https://token.actions.githubusercontent.com"

  validation {
    condition     = substr(var.github_actions_oidc_url, 0, 5) == "https"
    error_message = "The OIDC URL needs to start with https."
  }
}

variable "github_repositories" {
  description = "List of GitHub organization/repository names authorized to assume the role."
  type        = list(string)

  validation {
    // Ensures each element of github_repositories list matches the organization/repository format used by GitHub.
    condition = length([
      for repo in var.github_repositories : 1
      if length(regexall("^[A-Za-z0-9_.-]+?/([A-Za-z0-9_.:/-]+|\\*)$", repo)) > 0
    ]) == length(var.github_repositories)
    error_message = "Repositories must be specified in the organization/repository format."
  }
}

variable "github_thumbprint" {
  default     = "6938fd4d98bab03faadb97b34396831e3780aea1"
  description = "GitHub OpenID TLS certificate thumbprint."
  type        = string
}


/* -------------------------------------------------------------------------- */
/*                              SHARED_ROLE_ARNS                              */
/* -------------------------------------------------------------------------- */
variable "readonly_policy_arn" {
  description = "AWS built in readonly access policy arn"
  type        = string
  default     = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

variable "securityaudit_policy_arn" {
  description = "AWS built in securityaudit access policy arn"
  type        = string
  default     = "arn:aws:iam::aws:policy/SecurityAudit"
}

variable "ecr_readonly_policy_arn" {
  description = "AWS built in ECR readonly access policy arn"
  type        = string
  default     = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

variable "ecr_poweruser_policy_arn" {
  description = "AWS built in ECR PowerUser access policy arn"
  type        = string
  default     = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

variable "ecs_fullaccess_policy_arn" {
  description = "AWS built in ECS full access policy arn"
  type        = string
  default     = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}


/* -------------------------------------------------------------------------- */
/*                            SHARED_ROLE_VARIABLES                           */
/* -------------------------------------------------------------------------- */

variable "role_name_suffix" {
  description = "IAM role name to be <role_name><role_name_suffix>"
  type        = string
  default     = "GithubOIDCRole"
}

variable "iam_role_path" {
  default     = "/"
  description = "Path under which to create IAM role."
  type        = string
}

variable "iam_role_permissions_boundary" {
  default     = ""
  description = "ARN of the permissions boundary to be used by the IAM role."
  type        = string
}


variable "max_session_duration" {
  default     = 3600
  description = "Maximum session duration in seconds."
  type        = number

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "Maximum session duration must be between 3600 and 43200 seconds."
  }
}

variable "force_detach_policies" {
  default     = false
  description = "Flag to force detachment of policies attached to the IAM role."
  type        = string
}


/* -------------------------------------------------------------------------- */
/*                             CUSTOM_USER_ROLE                            */
/* -------------------------------------------------------------------------- */
variable "is_create_custom_oicd_role" {
  description = "Whether to create custom oidc role"
  type        = bool
  default     = false
}

variable "custom_role_name_prefix" {
  description =  "IAM role name to be <role_name>-GithubOIDCRole"
  type        = string
  default = "custom"
}

variable "custom_role_iam_policy_arns" {
  description = "AWS built in policies for custom role"
  type        = list(string)
  default     = []
}

variable "custom_iam_role_inline_policies" {
  default     = {}
  description = "Inline policies map with policy name as key and json as value."
  type        = map(string)
}


/* -------------------------------------------------------------------------- */
/*                             SECURITY_SCAN_OIDC_ROLE                            */
/* -------------------------------------------------------------------------- */
variable "is_create_securityscan_oicd_role" {
  description = "Whether to create securityscan oidc role"
  type        = bool
  default     = false
}

variable "securityscan_role_name_prefix" {
  description = "IAM role name to be <role_name>-GithubOIDCRole"
  type        = string
  default     = "SecurityScan"
}

/* -------------------------------------------------------------------------- */
/*                             ECR_OIDC_ROLE                            */
/* -------------------------------------------------------------------------- */
variable "is_create_ecrpush_oicd_role" {
  description = "Whether to create ecr readwrite oidc role"
  type        = bool
  default     = false
}

variable "ecrpush_role_name_prefix" {
  description = "IAM role name to be <role_name>-GithubOIDCRole"
  type        = string
  default     = "ECR_ReadWrite"
}


/* -------------------------------------------------------------------------- */
/*                             ECS_OIDC_ROLE                            */
/* -------------------------------------------------------------------------- */
variable "is_create_ecs_oicd_role" {
  description = "Whether to create ecs full access oidc role"
  type        = bool
  default     = false
}

variable "ecs_role_name_prefix" {
  description = "IAM role name to be <role_name>-GithubOIDCRole"
  type        = string
  default     = "ECS_FullAccess"
}
