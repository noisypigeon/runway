# A scoped key for running the deduplicate phase locally: an Object Storage
# policy on this project and an API key, both attached to pigeon-cli's shared
# IAM application. Applied from a worktree that was never committed, then
# brought into configuration as-is (RUN-0001 §6), and split by module under
# LIB-0004: this policy and its key are separate leaves that need no dependency,
# since both take the application from the shared pigeon-cli secret.
#
# The key expires 30 days after it was created (the iam-api-key module's
# default, pinned by its time_static); a fresh one is a replace of
# module.iam_api_key, then hand the new outputs to the job.
module "iam_api_key" {
  source = "https://pigeon.dev/modules/scaleway/iam-api-key/v0.2.0"

  application_id     = local.pigeon_cli_iam_application_id
  default_project_id = local.scaleway_project_id
}
