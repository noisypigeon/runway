output "access_key" {
  description = "Deployer API key access key -- hand-copy into terraform/secrets/scaleway.enc's SCALEWAY_PROVIDER_ACCESS_KEY_ID and terraform.enc's TERRAFORM_STATE_ACCESS_KEY_ID"
  value       = module.terraform_deployer_iam.access_key
  sensitive   = true
}

output "secret_key" {
  description = "Deployer API key secret key -- hand-copy into terraform/secrets/scaleway.enc's SCALEWAY_PROVIDER_ACCESS_KEY and terraform.enc's TERRAFORM_STATE_ACCESS_KEY"
  value       = module.terraform_deployer_iam.secret_key
  sensitive   = true
}
