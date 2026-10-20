output "name" {
  description = "State bucket name -- hand-copy into terraform/secrets/terraform.enc's TERRAFORM_STATE_BUCKET_NAME"
  value       = module.bucket.name
}
