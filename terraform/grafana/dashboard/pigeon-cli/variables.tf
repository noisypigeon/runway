variable "application_id" {
  type        = string
  description = "The pigeon-cli-grafana IAM application ID (Terragrunt dependency input)"
}

variable "grafana_auth_token" {
  type        = string
  description = "The pigeon-cli-grafana API key secret (Terragrunt dependency input)"
  sensitive   = true
}
