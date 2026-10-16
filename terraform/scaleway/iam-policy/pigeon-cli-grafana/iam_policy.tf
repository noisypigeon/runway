module "iam_policy" {
  source = "https://noisypigeon.garden/terraform/scaleway/iam-policy/v4.0.0"
  name   = "pigeon-cli-grafana-policy"

  application_id          = var.application_id
  project_ids             = [local.scaleway_project_id]
  project_permission_sets = ["ObservabilityGrafanaEditor"]
}
