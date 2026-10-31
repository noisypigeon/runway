output "id" {
  description = "Token ID"
  value       = cloudflare_account_token.this.id
}

output "token" {
  description = "The token's secret value"
  value       = cloudflare_account_token.this.value
  sensitive   = true
}

# R2's S3 API signs in with a token's ID as the access key and the SHA-256 of
# its value as the secret (LIB-0051 §2), so a bucket-scoped token is also an
# S3 credential for that bucket.
output "s3_access_key_id" {
  description = "The token as an R2 S3 access key ID"
  value       = cloudflare_account_token.this.id
}

output "s3_secret_access_key" {
  description = "The token as an R2 S3 secret access key: the SHA-256 of its value"
  value       = sha256(cloudflare_account_token.this.value)
  sensitive   = true
}
