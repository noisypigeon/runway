# A scoped key for running the deduplicate phase locally: an Object Storage
# policy on this project, attached to pigeon-cli's shared IAM application, and
# an API key for that application. Applied from a worktree that was never
# committed, then brought into configuration as-is (RUN-0001) so a plan keeps
# it instead of destroying a key a running job holds.
#
# The key expires 30 days after it was created (the iam-api-key module's
# default, pinned by its time_static); a fresh one is a replace of
# module.iam_api_key, then hand the new outputs to the job.
module "iam_policy" {
  source = "https://pigeon.dev/modules/scaleway/iam-policy/v4.0.0"
  name   = "pigeon-deduplicate-local-key"

  application_id          = local.pigeon_cli_iam_application_id
  project_ids             = [local.scaleway_project_id]
  project_permission_sets = ["ObjectStorageFullAccess"]
}

module "iam_api_key" {
  source = "https://pigeon.dev/modules/scaleway/iam-api-key/v0.2.0"

  application_id     = local.pigeon_cli_iam_application_id
  default_project_id = local.scaleway_project_id
}
