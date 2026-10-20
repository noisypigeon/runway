module "bucket" {
  source            = "https://noisypigeon.garden/terraform/scaleway/bucket/v5.0.0"
  name_prefix       = local.name_prefix
  name_suffix       = local.name_suffix
  project_id        = local.scaleway_project_id
  enable_versioning = true
  storage_class     = "standard"
}
