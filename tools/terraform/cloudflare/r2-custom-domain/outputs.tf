output "domain" {
  description = "The hostname the bucket is served on"
  value       = cloudflare_r2_custom_domain.this.domain
}

output "zone_id" {
  description = "ID of the zone looked up from `zone`"
  value       = data.cloudflare_zone.this.id
}
