+++
title = "scaleway/cockpit-observability"
description = "A Scaleway Cockpit (`scaleway_cockpit_source`/`scaleway_cockpit_token`) wrapper that creates a metrics and/or logs source plus a shared push token, each individually toggleable via `enable_metrics`/`enable_logs`."
template = "module.html"
in_search_index = true

[extra]
kind = "module"
provider = "scaleway"
module = "cockpit-observability"
latest_version = "0.1.0"
github_url = "https://github.com/noisypigeon/runway/tree/main/lib/terraform/scaleway/cockpit-observability"
usage_example = """
module "cockpit" {
  source = "https://noisypigeon.garden/terraform/scaleway/cockpit-observability/v0.1.0"

  name       = "pigeon-cli"
  project_id = local.scaleway_project_id
}
"""
versions = [{ version = "0.1.0", path = "terraform/scaleway/cockpit-observability/v0.1.0" }]
+++
