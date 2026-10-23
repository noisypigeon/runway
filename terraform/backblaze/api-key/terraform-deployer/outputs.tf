output "application_key_id" {
  description = "Deployer key ID -- hand-copy into terraform/secrets/backblaze.enc's BACKBLAZE_PROVIDER_ACCESS_KEY_ID (LIB-0033 §2)"
  value       = module.key.application_key_id
}

output "application_key" {
  description = "Deployer key -- hand-copy into terraform/secrets/backblaze.enc's BACKBLAZE_PROVIDER_ACCESS_KEY (LIB-0033 §2)"
  value       = module.key.application_key
  sensitive   = true
}
