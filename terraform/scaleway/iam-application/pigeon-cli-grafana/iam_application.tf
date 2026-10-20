module "iam_application" {
  source = "https://noisypigeon.garden/terraform/scaleway/iam-application/v0.1.0"
  name   = "pigeon-cli-grafana"
}

output "id" {
  description = "IAM application ID -- read by the pigeon-cli-grafana policy, API key and dashboard leaves through Terragrunt dependency blocks"
  value       = module.iam_application.id
}
