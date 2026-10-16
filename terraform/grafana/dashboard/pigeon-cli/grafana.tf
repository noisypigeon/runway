# The grafana provider and the scaleway_cockpit_grafana data source come from
# the root template (spoke.hcl's providers map); they authenticate with this key.
locals {
  grafana_auth_token = var.grafana_auth_token
}

# Dashboards are versioned in pigeon-lib's grafana-dashboards/pigeon-cli track
# and fetched by tag URL -- pigeon-cli's own observability stack ships a copy
# of the same JSON. The first-access ping Scaleway's Grafana needs before any
# dashboard (ADR-0135) is the module's first_access, re-run when the IAM
# application changes.
module "grafana_dashboard" {
  source = "https://pigeon.dev/modules/grafana/dashboard/v0.1.0"

  folder_title = "pigeon-cli"
  dashboards = {
    overview = { url = "https://raw.githubusercontent.com/noisypigeon/pigeon-lib/refs/tags/grafana-dashboards/pigeon-cli/v1.0.0/grafana-dashboards/pigeon-cli/overview.json" }
  }

  first_access = {
    grafana_url = data.scaleway_cockpit_grafana.grafana.grafana_url
    trigger     = var.application_id
  }
  first_access_auth_token = local.grafana_auth_token
}
