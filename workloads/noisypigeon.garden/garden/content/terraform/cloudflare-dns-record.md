+++
title = "cloudflare/dns-record"
description = "A thin wrapper around a single `cloudflare_dns_record`. It adds no behaviour: every argument is passed through as given, and an optional argument left `null` stays unset rather than picking up a default here. It exists so that a leaf managing DNS records calls a library module, like every other leaf (LIB-0004). It's **zone-scoped**: a spoke declares it as `cloudflare.dnsRecord.<instance>` in `zones/<zone>/zone.yaml`, or in the `values.yaml` of the workload that zone names, and `resolve-workloads.sh` generates its leaf (LIB-0036). The hand-written `terraform/cloudflare/<zone>/dns-record/<instance>/` leaves LIB-0008 described are refused since `terragrunt/root-hcl` v6.0.0. The module takes the zone's apex as `zone` and looks the zone ID up itself with `data \"cloudflare_zone\"`, so no zone ID is kept in a secret (LIB-0011). The lookup needs a token with **Zone:Read** on the zone as well as DNS edit. The ID it found is the `zone_id` output."
template = "module.html"
in_search_index = true

[extra]
kind = "module"
provider = "cloudflare"
module = "dns-record"
latest_version = "1.0.0"
github_url = "https://github.com/noisypigeon/runway/tree/main/lib/terraform/cloudflare/dns-record"
usage_example = """
locals {
  records = {
    mx_primary = {
      name     = "@"
      type     = "MX"
      content  = "in1-smtp.example.com"
      priority = 10
      comment  = "primary mx"
    }
    www_cname = {
      name    = "www"
      type    = "CNAME"
      content = "example.github.io"
      proxied = false
    }
  }
}

module "dns_record" {
  source   = "https://noisypigeon.garden/terraform/cloudflare/dns-record/v1.0.0"
  for_each = local.records

  zone     = local.cloudflare_zone
  name     = each.value.name
  type     = each.value.type
  content  = each.value.content
  ttl      = try(each.value.ttl, 1)
  proxied  = try(each.value.proxied, null)
  priority = try(each.value.priority, null)
  comment  = try(each.value.comment, null)
}
"""
versions = [{ version = "0.1.0", path = "terraform/cloudflare/dns-record/v0.1.0" }, { version = "1.0.0", path = "terraform/cloudflare/dns-record/v1.0.0" }]
+++
