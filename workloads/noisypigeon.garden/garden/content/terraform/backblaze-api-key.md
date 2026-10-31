+++
title = "backblaze/api-key"
description = "A thin wrapper around `b2_application_key`. Takes a required `capabilities` set and an optional `bucket_ids` set to scope the key to specific buckets (composes naturally with `backblaze/bucket`'s own `bucket_id` output). Defaults `valid_duration_in_seconds` to 30 days, mirroring `scaleway/iam-api-key`'s own default-expiry policy for new credentials. With `rotation_days` (v0.2.0, LIB-0041 §1), the key is replaced every `rotation_days`, create-before-destroy, and each key expires a week after its scheduled rotation, as `cloudflare/api-token`'s token does. It overrides `valid_duration_in_seconds`."
template = "module.html"
in_search_index = true

[extra]
kind = "module"
provider = "backblaze"
module = "api-key"
latest_version = "0.2.0"
github_url = "https://github.com/noisypigeon/runway/tree/main/tools/terraform/backblaze/api-key"
usage_example = """
module "backup_key" {
  source       = "https://noisypigeon.garden/terraform/backblaze/api-key/v0.1.0"
  key_name     = "backup-writer"
  capabilities = ["listFiles", "readFiles", "writeFiles"]
  bucket_ids   = [module.backup_bucket.bucket_id]
}
"""
versions = [{ version = "0.1.0", path = "terraform/backblaze/api-key/v0.1.0" }, { version = "0.1.1", path = "terraform/backblaze/api-key/v0.1.1" }, { version = "0.2.0", path = "terraform/backblaze/api-key/v0.2.0" }]
+++
