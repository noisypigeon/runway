+++
title = "scaleway/iam-api-key"
description = "A thin wrapper around `scaleway_iam_api_key`. Split out of `iam-policy` (ADR-0119) so a credential's lifecycle is independent of the application/policy it authenticates for. Defaults `expires_at` to 30 days after the key is first created, anchored via a `time_static` resource so the default doesn't drift on every `plan`."
template = "module.html"
in_search_index = true

[extra]
kind = "module"
provider = "scaleway"
module = "iam-api-key"
latest_version = "0.3.0"
github_url = "https://github.com/noisypigeon/library/tree/main/terraform/scaleway/iam-api-key"
usage_example = """
module "iam_api_key" {
  source         = "https://noisypigeon.garden/terraform/scaleway/iam-api-key/v0.1.0"
  application_id = module.iam_application.id
}
"""
versions = [{ version = "0.1.0", path = "terraform/scaleway/iam-api-key/v0.1.0" }, { version = "0.2.0", path = "terraform/scaleway/iam-api-key/v0.2.0" }, { version = "0.3.0", path = "terraform/scaleway/iam-api-key/v0.3.0" }]
+++
