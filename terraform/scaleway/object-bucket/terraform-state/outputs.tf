output "name" {
  description = "State bucket name -- hand-copy into terraform/secrets.enc's WILLOWGRAYSEN_COM_TERRAFORM_STATE_BUCKET_NAME"
  value       = module.bucket.name
}
