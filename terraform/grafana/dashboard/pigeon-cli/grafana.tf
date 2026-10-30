# The generated grafana provider authenticates with this key.
locals {
  grafana_auth_token = var.grafana_auth_token
}

module "grafana_dashboard" {
  source = "https://noisypigeon.garden/terraform/grafana/dashboard/v0.1.0"

  folder_title = "pigeon-cli"
  dashboards = {
    overview = { url = "https://raw.githubusercontent.com/noisypigeon/runway/refs/tags/grafana-dashboards/pigeon-cli/v1.0.0/lib/grafana-dashboards/pigeon-cli/overview.json" }
  }

  # Scaleway's Grafana needs a first-access ping before any dashboard.
  first_access = {
    grafana_url = data.scaleway_cockpit_grafana.grafana.grafana_url
    trigger     = var.application_id
  }
  first_access_auth_token = local.grafana_auth_token
}
