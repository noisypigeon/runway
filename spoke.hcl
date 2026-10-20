# Read by the generated /root.hcl. Bump root_hcl_version, then `mise run terraform-prepare`.
locals {
  root_hcl_version = "4.1.0"

  # A Grafana leaf must define local.grafana_auth_token.
  providers = {
    scaleway  = {}
    backblaze = { leaves = ["terraform/backblaze/bucket/"] }
    grafana   = { leaves = ["terraform/grafana/dashboard/"] }
  }
}
