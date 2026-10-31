+++
title = "scaleway/iam-policy"
description = "A Scaleway `scaleway_iam_policy` wrapper granting organization/project permission-set rules to an existing IAM application. Split from a formerly application+policy+API-key bundle (ADR-0119) — pair with `iam-application` (to create the application) and `iam-api-key` (to mint a credential for it)."
template = "module.html"
in_search_index = true

[extra]
kind = "module"
provider = "scaleway"
module = "iam-policy"
latest_version = "4.0.0"
github_url = "https://github.com/noisypigeon/runway/tree/main/tools/terraform/scaleway/iam-policy"
usage_example = """
module "iam_application" {
  source = "https://noisypigeon.garden/terraform/scaleway/iam-application/v0.1.0"
  name   = "pigeon-cli"
}

module "iam_policy" {
  source = "https://noisypigeon.garden/terraform/scaleway/iam-policy/v4.0.0"
  name   = "pigeon-cli"

  application_id = module.iam_application.id

  project_ids              = [local.scaleway_project_id]
  project_permission_sets  = ["ObjectStorageFullAccess"]
}

module "iam_api_key" {
  source         = "https://noisypigeon.garden/terraform/scaleway/iam-api-key/v0.1.0"
  application_id = module.iam_application.id
}
"""
versions = [{ version = "3.0.0", path = "terraform/scaleway/iam-policy/v3.0.0" }, { version = "4.0.0", path = "terraform/scaleway/iam-policy/v4.0.0" }]
+++
