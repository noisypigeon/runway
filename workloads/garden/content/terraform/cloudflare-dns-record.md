+++
title = "cloudflare/dns-record"
description = "A thin wrapper around a single `cloudflare_dns_record`. It adds no behaviour: every argument is passed through as given, and an optional argument left `null` stays unset rather than picking up a default here. It exists so that a leaf managing DNS records calls a library module, like every other leaf (LIB-0004). It's **zone-scoped**: a leaf calling it lives at `terraform/cloudflare/<zone>/dns-record/<instance>/`, where `<zone>` is the zone's apex domain (LIB-0008). The module takes that apex as `zone` and looks the zone ID up itself with `data \"cloudflare_zone\"`, so the leaf passes `zone = local.cloudflare_zone`, which `terragrunt/root-hcl` derives from the path, and no zone ID is kept in a secret (LIB-0011). The lookup needs a token with **Zone:Read** on the zone as well as DNS edit. The ID it found is the `zone_id` output."
template = "module.html"
in_search_index = true

[extra]
kind = "module"
provider = "cloudflare"
module = "dns-record"
latest_version = "1.0.0"
github_url = "https://github.com/noisypigeon/library/tree/main/terraform/cloudflare/dns-record"
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
