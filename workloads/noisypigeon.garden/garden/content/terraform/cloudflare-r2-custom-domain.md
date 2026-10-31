+++
title = "cloudflare/r2-custom-domain"
description = "One R2 bucket served on one hostname of a Cloudflare zone (`cloudflare_r2_custom_domain`), for a site workload's `deployments.cloudflare` (LIB-0051 §2). - **The zone is looked up by its apex,** as `dns-record` does (LIB-0011), so a leaf needs no zone ID. - **The bucket is addressed in R2's `eu` jurisdiction,** where every family bucket is (LIB-0006). There's no input to change it. - **It is one resource.** A bucket on its apex and on `www` is two instances, composed beside `cloudflare/bucket` as LIB-0038 composes deployers."
template = "module.html"
in_search_index = true

[extra]
kind = "module"
provider = "cloudflare"
module = "r2-custom-domain"
latest_version = "0.1.0"
github_url = "https://github.com/noisypigeon/runway/tree/main/tools/terraform/cloudflare/r2-custom-domain"
usage_example = """
module "custom_domain" {
  source = "https://noisypigeon.garden/terraform/cloudflare/r2-custom-domain/v0.1.0"

  account_id  = local.cloudflare_account_id
  zone        = "example.com"
  bucket_name = "example.com"
  domain      = "example.com"
}
"""
versions = [{ version = "0.1.0", path = "terraform/cloudflare/r2-custom-domain/v0.1.0" }]
+++
