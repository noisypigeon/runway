# Read by the generated /root.hcl. Bump root_hcl_version, then `mise run terraform-prepare`.
locals {
  root_hcl_version = "5.5.0"

  # A Grafana leaf must define local.grafana_auth_token.
  providers = {
    scaleway = {}
    # The bootstrap keys in *_breakglass.enc can only mint keys, and only the
    # deployer leaves read them; every other leaf signs in with the key those
    # leaves mint, hand-copied into cloudflare.enc and backblaze.enc (LIB-0033).
    backblaze = {
      leaves     = ["terraform/backblaze/"]
      breakglass = { leaves = ["terraform/backblaze/api-key/terraform-deployer/"] }
    }
    cloudflare = {
      leaves     = ["terraform/cloudflare/"]
      breakglass = { leaves = ["terraform/cloudflare/api-token/terraform-deployer/"] }
    }
    grafana = { leaves = ["terraform/grafana/dashboard/"] }
  }
}
