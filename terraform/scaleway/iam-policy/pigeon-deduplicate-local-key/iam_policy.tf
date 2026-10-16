# A scoped key for running the deduplicate phase locally: an Object Storage
# policy on this project and an API key, both attached to pigeon-cli's shared
# IAM application. Applied from a worktree that was never committed, then
# brought into configuration as-is (RUN-0001 §6), and split by module under
# LIB-0004: this policy and its key are separate leaves that need no dependency,
# since both take the application from the shared pigeon-cli secret.
module "iam_policy" {
  source = "https://pigeon.dev/modules/scaleway/iam-policy/v4.0.0"
  name   = "pigeon-deduplicate-local-key"

  application_id          = local.pigeon_cli_iam_application_id
  project_ids             = [local.scaleway_project_id]
  project_permission_sets = ["ObjectStorageFullAccess"]
}
