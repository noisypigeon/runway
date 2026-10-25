+++
title = "cloudflare/apex-redirect"
description = "Redirects a Cloudflare zone's apex, and `www` with it, to a single URL. It manages the three things a redirect needs, which used to be two leaves calling `cloudflare/dns-record` and `cloudflare/ruleset` (LIB-0011): - a proxied placeholder `A @ 192.0.2.1` record, so Cloudflare sees apex traffic (192.0.2.1 is documentation space that routes nowhere; the ruleset answers first); - a proxied placeholder `CNAME www → <zone>` record, unless `include_www` is false; - one `http_request_dynamic_redirect` ruleset whose rule sends both hosts to `target_url` with `status_code`. Every request goes to `target_url` itself; the path isn't preserved. The query string is appended only when `preserve_query_string` is true. It's **zone-scoped**: a leaf calling it lives at `terraform/cloudflare/<zone>/apex-redirect/<instance>/`, where `<zone>` is the zone's apex domain (LIB-0008). The module looks the zone ID up from `zone` with `data \"cloudflare_zone\"`, so the leaf passes `zone = local.cloudflare_zone` and no zone ID is kept in a secret. The token needs **Zone:Read** on the zone, as well as DNS and ruleset edit. The module owns its resources directly rather than calling other library modules: a module that sources another by short URL breaks when that URL's host moves (LIB-0009)."
template = "module.html"
in_search_index = true

[extra]
kind = "module"
provider = "cloudflare"
module = "apex-redirect"
latest_version = "0.1.0"
github_url = "https://github.com/noisypigeon/library/tree/main/terraform/cloudflare/apex-redirect"
usage_example = """
module "apex_redirect" {
  source = "https://noisypigeon.garden/terraform/cloudflare/apex-redirect/v0.1.0"

  zone       = local.cloudflare_zone
  target_url = "https://example.org"
}
"""
versions = [{ version = "0.1.0", path = "terraform/cloudflare/apex-redirect/v0.1.0" }]
+++
