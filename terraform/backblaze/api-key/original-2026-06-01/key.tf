module "key" {
  source       = "https://noisypigeon.garden/terraform/backblaze/api-key/v0.1.1"
  key_name     = "${local.bucket_name}-key"
  bucket_ids   = [local.bucket_id]
  capabilities = local.key_capabilities
}

output "application_key_id" {
  value       = module.key.application_key_id
  description = "application_key_id"
}

output "application_key" {
  value       = module.key.application_key
  description = "application_key"
  sensitive    = true
}
