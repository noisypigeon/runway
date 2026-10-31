+++
title = "cloudflare/bucket"
description = "A Cloudflare R2 bucket (`cloudflare_r2_bucket`), named the way `backblaze/bucket` and `scaleway/bucket` name theirs: `{name_prefix}-{random_code}-{name_suffix}`, or exactly `exact_name`. - **Every bucket is in R2's `eu` jurisdiction.** Cloudflare enforces it, and there's no input to change it. There is no location hint either, since R2 doesn't always respect one (LIB-0006). - **`storage_class` defaults to `Standard`.** `InfrequentAccess` is the alternative. It exists so that a leaf managing an R2 bucket calls a library module and can live at `terraform/cloudflare/bucket/<instance>/`, like every other leaf (LIB-0004). It's **account-level**, not zone-scoped, so its path has no zone segment (LIB-0008)."
template = "module.html"
in_search_index = true

[extra]
kind = "module"
provider = "cloudflare"
module = "bucket"
latest_version = "1.0.0"
github_url = "https://github.com/noisypigeon/runway/tree/main/tools/terraform/cloudflare/bucket"
usage_example = """
module "bucket" {
  source = "https://noisypigeon.garden/terraform/cloudflare/bucket/v1.0.0"

  account_id  = local.cloudflare_account_id
  name_prefix = "example-com"
  name_suffix = "assets"
}
"""
versions = [{ version = "0.1.0", path = "terraform/cloudflare/bucket/v0.1.0" }, { version = "1.0.0", path = "terraform/cloudflare/bucket/v1.0.0" }]
+++
