# This spoke's instance values for pigeon-lib's root.hcl template (LIB-0003,
# RUN-0001). /root.hcl is generated from that template at root_hcl_version by
# pigeon-lib's resolve-root-hcl.sh and committed -- never edit it by hand; CI
# fails if it drifts. The template reads the rest of these locals back out of
# this file.
locals {
  # pigeon-lib tag terragrunt/root-hcl/v<version>, or "main" for the fetched
  # clone's working tree. Bumping it is how this repo takes a template change.
  root_hcl_version = "4.1.0"

  # Which providers this spoke's leaves get (LIB-0005). A provider absent from
  # the map is off; `leaves` scopes one to path prefixes ending in "/". A
  # Grafana leaf must define local.grafana_auth_token. Scaleway's breakglass
  # (LIB-0014): only the deployer IAM leaf signs in with the hand-made key in
  # terraform/secrets/scaleway_breakglass.enc -- for both the provider and the
  # state -- because it manages the key every other leaf uses.
  providers = {
    scaleway = {
      breakglass = { leaves = ["terraform/scaleway/terraform-deployer-iam/"] }
    }
    backblaze = { leaves = ["terraform/backblaze/bucket/"] }
    grafana   = { leaves = ["terraform/grafana/dashboard/"] }
  }
}
