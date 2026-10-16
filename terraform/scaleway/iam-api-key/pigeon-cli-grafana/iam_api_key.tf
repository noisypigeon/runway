module "iam_api_key" {
  source = "https://pigeon.dev/modules/scaleway/iam-api-key/v0.2.0"

  application_id     = var.application_id
  default_project_id = local.scaleway_project_id
}

output "secret_key" {
  description = "Grafana API key secret -- read by the pigeon-cli grafana-dashboard leaf through a Terragrunt dependency; never print it"
  value       = module.iam_api_key.secret_key
  sensitive   = true
}
