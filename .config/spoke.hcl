# Read by the generated /root.hcl. Bump root_hcl_version, then `mise run terraform-prepare`.
locals {
  root_hcl_version = "11.2.0"

  # Rotation (LIB-0054 §6.2): every API key and token a unit's kinds create is
  # at this generation; bump it to rotate them all. pigeon.dev's canary ran at
  # 1 already (noisypigeon/runway#204), so it doesn't change again.
  rotation_generation = 1

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
