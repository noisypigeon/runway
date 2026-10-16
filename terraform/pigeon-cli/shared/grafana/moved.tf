# This leaf's own first-access hook moved into scaleway/grafana-dashboard
# v0.2.0 without being re-run (LIB-0004 §3).
moved {
  from = terraform_data.grafana_first_access
  to   = module.grafana_dashboard.terraform_data.first_access[0]
}
