# Expires 30 days after creation. Renew by replacing module.iam_api_key and handing the new outputs to the job.
module "iam_api_key" {
  source = "https://noisypigeon.garden/terraform/scaleway/iam-api-key/v0.2.0"

  application_id     = local.pigeon_cli_iam_application_id
  default_project_id = local.scaleway_project_id
}
