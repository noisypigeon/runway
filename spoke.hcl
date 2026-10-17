# This spoke's instance values for pigeon-lib's root.hcl template (LIB-0003,
# RUN-0001). /root.hcl is generated from that template at root_hcl_version by
# pigeon-lib's resolve-root-hcl.sh and committed -- never edit it by hand; CI
# fails if it drifts. The template reads the rest of these locals back out of
# this file.
locals {
  # pigeon-lib tag terragrunt/root-hcl/v<version>, or "main" for the fetched
  # clone's working tree. Bumping it is how this repo takes a template change.
  root_hcl_version = "3.0.0"

  # Which providers this spoke's leaves get (LIB-0005). A provider absent from
  # the map is off; `leaves` scopes one to path prefixes ending in "/". A
  # Grafana leaf must define local.grafana_auth_token.
  providers = {
    scaleway  = {}
    backblaze = { leaves = ["terraform/backblaze/bucket/"] }
    grafana   = { leaves = ["terraform/grafana/dashboard/"] }
  }
}
