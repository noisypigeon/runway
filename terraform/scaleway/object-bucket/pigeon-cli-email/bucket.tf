module "bucket" {
  source      = "https://noisypigeon.garden/terraform/scaleway/bucket/v5.0.0"
  name_prefix = local.name_prefix
  name_suffix = local.name_suffix
  storage_class   = "glacier"
}
