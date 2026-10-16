# This spoke's instance values for pigeon-lib's root.hcl template (LIB-0003,
# RUN-0001). /root.hcl is generated from that template at root_hcl_version by
# pigeon-lib's resolve-root-hcl.sh and committed -- never edit it by hand; CI
# fails if it drifts. The template reads the rest of these locals back out of
# this file.
locals {
  # pigeon-lib tag terragrunt/root-hcl/v<version>, or "main" for the fetched
  # clone's working tree. Bumping it is how this repo takes a template change.
  root_hcl_version = "1.2.0"

  # terraform/secrets.enc key naming this spoke's own state bucket (ADR-0133).
  state_bucket_secret = "WILLOWGRAYSEN_COM_TERRAFORM_STATE_BUCKET_NAME"

  # DEV-0148's latent Backblaze B2 provider; a leaf opts in with a sibling
  # backblaze_config.hcl setting `enabled = true` (the cold/* leaves do).
  backblaze = true

  # The template's latent Scaleway Cockpit Grafana provider (v1.2.0); a leaf
  # opts in with grafana_config.hcl and defines local.grafana_auth_token.
  grafana = true
}
