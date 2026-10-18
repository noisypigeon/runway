module "bucket" {
  source      = "https://noisypigeon.garden/terraform/scaleway/object-bucket/v4.2.0"
  name_prefix = local.name_prefix
  name_suffix = local.name_suffix
  storage_class   = "standard"
}
