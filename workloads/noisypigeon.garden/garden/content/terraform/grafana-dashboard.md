+++
title = "grafana/dashboard"
description = "A `grafana_folder`/`grafana_dashboard` wrapper that creates a Grafana folder and provisions a set of dashboards into it from JSON dashboard models. See [ADR-0135](https://github.com/noisypigeon/noisypigeon/blob/main/docs/adr/0135-grafana-dashboards-as-code.md) for why a dedicated folder is required (Scaleway Cockpit's own preconfigured dashboards live in a folder that is always read-only) and how the `grafana` provider itself is authenticated against Cockpit (wired by the consuming leaf, not this module). Released as `scaleway/grafana-dashboard` up to v0.2.0. It uses only the `grafana` provider, so it moved to `grafana/dashboard` and restarted its tag track at v0.1.0, with the same inputs, outputs and resource addresses as `scaleway/grafana-dashboard` v0.2.0. The old short URLs keep resolving."
template = "module.html"
in_search_index = true

[extra]
kind = "module"
provider = "grafana"
module = "dashboard"
latest_version = "0.1.0"
github_url = "https://github.com/noisypigeon/runway/tree/main/lib/terraform/grafana/dashboard"
usage_example = """
module "grafana_dashboard" {
  source = "https://noisypigeon.garden/terraform/grafana/dashboard/v0.1.0"

  folder_title = "pigeon-cli"
  dashboards = {
    # A pinned version from the library's grafana-dashboards track...
    overview = { url = "https://raw.githubusercontent.com/noisypigeon/runway/refs/tags/grafana-dashboards/pigeon-cli/v1.0.0/lib/grafana-dashboards/pigeon-cli/overview.json" }
    # ...or an inline JSON model.
    # local_one = { config_json = file("${path.module}/local.json") }
  }

  # Optional: Scaleway's Grafana provisions an IAM identity's role
  # lazily on first API access, so ping it once, before anything is created.
  first_access = {
    grafana_url = data.scaleway_cockpit_grafana.grafana.grafana_url
    trigger     = local.iam_application_id # re-ping when the identity changes
  }
  first_access_auth_token = local.grafana_auth_token
}
"""
versions = [{ version = "0.1.0", path = "terraform/grafana/dashboard/v0.1.0" }]
+++
