+++
title = "cloudflare/ruleset"
description = "> **End-of-life.** This module gets no further releases. Its existing tags stay > resolvable, so a leaf pinned to one keeps working, but its only use was > redirects, and those now use > [`cloudflare/apex-redirect`](../apex-redirect/README.md), one leaf that owns > the placeholder records and the ruleset together (LIB-0011). A future > non-redirect use of `cloudflare_ruleset` gets its own module rather than a > revived `ruleset`. A thin wrapper around a single `cloudflare_ruleset`. It adds no behaviour: the `rules` list goes to the provider exactly as given, and `description` left `null` stays unset. It exists so that a leaf managing a ruleset calls a library module (LIB-0004). It's **zone-scoped**: a leaf calling it lives at `terraform/cloudflare/<zone>/ruleset/<instance>/`, where `<zone>` is the zone's apex domain. `terragrunt/root-hcl` v2.2.0 then gives the leaf `local.cloudflare_zone_id` for that zone (LIB-0008)."
template = "module.html"
in_search_index = true

[extra]
kind = "module"
provider = "cloudflare"
module = "ruleset"
latest_version = "0.2.0"
github_url = "https://github.com/noisypigeon/library/tree/main/terraform/cloudflare/ruleset"
usage_example = """
module "ruleset" {
  source = "https://noisypigeon.garden/terraform/cloudflare/ruleset/v0.1.0"

  zone_id = local.cloudflare_zone_id
  name    = "example.com to example.org redirect"
  kind    = "zone"
  phase   = "http_request_dynamic_redirect"

  rules = [{
    expression  = "(http.host eq \"example.com\")"
    description = "redirect example.com to example.org"
    action      = "redirect"
    action_parameters = {
      from_value = {
        status_code           = 301
        target_url            = { value = "https://example.org" }
        preserve_query_string = false
      }
    }
  }]
}
"""
versions = [{ version = "0.1.0", path = "terraform/cloudflare/ruleset/v0.1.0" }, { version = "0.2.0", path = "terraform/cloudflare/ruleset/v0.2.0" }]
+++
