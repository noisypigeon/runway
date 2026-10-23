output "token" {
  description = "Deployer token -- hand-copy into terraform/secrets/cloudflare.enc's CLOUDFLARE_PROVIDER_TOKEN (LIB-0033 §2)"
  value       = module.token.token
  sensitive   = true
}
