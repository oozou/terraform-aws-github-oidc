variable "aws_account" {
  description = "AWS Credentials to access AWS"
  type = object({
    region     = string,
    access_key = string,
    secret_key = string
  })
  sensitive = true
  # Ex: { access_key = "", secret_key = "", region = "" }
}
