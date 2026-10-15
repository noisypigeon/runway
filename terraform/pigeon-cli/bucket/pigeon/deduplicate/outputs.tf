output "access_key" {
  description = "Local deduplicate job's API access key -- read with `terragrunt output -raw access_key`, never paste it anywhere"
  value       = module.iam_api_key.access_key
  sensitive   = true
}

output "secret_key" {
  description = "Local deduplicate job's API secret key -- read with `terragrunt output -raw secret_key`, never paste it anywhere"
  value       = module.iam_api_key.secret_key
  sensitive   = true
}
