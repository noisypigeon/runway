# One R2 bucket served on one hostname of a Cloudflare zone (LIB-0051 §2).
# The zone is looked up by its apex, as dns-record v1 does (LIB-0011), and the
# bucket is in the eu jurisdiction, as every family bucket is (LIB-0006):
# R2's custom-domain API addresses an EU bucket only with that jurisdiction.
data "cloudflare_zone" "this" {
  filter = {
    name = var.zone
  }
}

resource "cloudflare_r2_custom_domain" "this" {
  account_id   = var.account_id
  bucket_name  = var.bucket_name
  jurisdiction = "eu"
  domain       = var.domain
  zone_id      = data.cloudflare_zone.this.id
  enabled      = var.enabled
  min_tls      = var.min_tls
}
