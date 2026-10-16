# Opts this leaf into the root template's latent Scaleway Cockpit Grafana
# provider (terragrunt/root-hcl v1.2.0). The provider authenticates with
# local.grafana_auth_token, defined in grafana.tf.
locals {
  enabled = true
}
