# Signs in with this spoke's Scaleway key, which it doesn't manage. If it ever does, it needs a breakglass key.
module "iam_api_key" {
  source = "https://noisypigeon.garden/terraform/scaleway/iam-api-key/v0.2.0"

  application_id     = var.application_id
  default_project_id = local.scaleway_project_id
}

output "access_key" {
  description = "Deployer API key access key -- hand-copy into terraform/secrets/scaleway.enc's SCALEWAY_PROVIDER_ACCESS_KEY_ID and terraform.enc's TERRAFORM_STATE_ACCESS_KEY_ID"
  value       = module.iam_api_key.access_key
  sensitive   = true
}

output "secret_key" {
  description = "Deployer API key secret key -- hand-copy into terraform/secrets/scaleway.enc's SCALEWAY_PROVIDER_ACCESS_KEY and terraform.enc's TERRAFORM_STATE_ACCESS_KEY"
  value       = module.iam_api_key.secret_key
  sensitive   = true
}
