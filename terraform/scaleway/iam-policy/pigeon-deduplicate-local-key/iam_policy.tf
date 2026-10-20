module "iam_policy" {
  source = "https://noisypigeon.garden/terraform/scaleway/iam-policy/v4.0.0"
  name   = "pigeon-deduplicate-local-key"

  application_id          = local.pigeon_cli_iam_application_id
  project_ids             = [local.scaleway_project_id]
  project_permission_sets = ["ObjectStorageFullAccess"]
}
