# Read by the generated /root.hcl. Bump root_hcl_version, then `mise run terraform-prepare`.
locals {
  root_hcl_version = "8.1.0"

  # A Grafana leaf must define local.grafana_auth_token.
  providers = {
    scaleway = {}
    # No spoke-wide Cloudflare token or Backblaze key: every leaf of these is a
    # unit's, signed in with its own token or key, which the minting-only
    # bootstrap key in *_breakglass.enc mints (LIB-0033, LIB-0041).
    backblaze  = { workloads_only = true, breakglass = {} }
    cloudflare = { workloads_only = true, breakglass = {} }
    grafana    = { leaves = ["terraform/grafana/dashboard/"] }
  }
}
