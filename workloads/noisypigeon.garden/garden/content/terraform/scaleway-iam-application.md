+++
title = "scaleway/iam-application"
description = "A thin wrapper around `scaleway_iam_application`. Split out of `iam-policy` (ADR-0119) so one application can be shared across several `iam-policy` calls instead of each policy minting its own."
template = "module.html"
in_search_index = true

[extra]
kind = "module"
provider = "scaleway"
module = "iam-application"
latest_version = "0.1.0"
github_url = "https://github.com/noisypigeon/library/tree/main/terraform/scaleway/iam-application"
usage_example = """
module "iam_application" {
  source = "https://noisypigeon.garden/terraform/scaleway/iam-application/v0.1.0"
  name   = "pigeon-cli"
}
"""
versions = [{ version = "0.1.0", path = "terraform/scaleway/iam-application/v0.1.0" }]
+++
