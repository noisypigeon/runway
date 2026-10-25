+++
title = "scaleway/terraform-deployer-iam"
description = "A spoke's Terraform deployer identity in one call: a `scaleway_iam_application`, its `scaleway_iam_policy`, and a `scaleway_iam_api_key` for it (LIB-0014). It rolls up `iam-application`, `iam-policy` and `iam-api-key` with the same inputs, inlined rather than nested so the resource addresses are fixed and a short URL can't break underneath it. The leaf that calls it manages the key every other leaf deploys with, so it must not authenticate with that key itself. Allowlist the leaf for the spoke's Scaleway breakglass credential in `spoke.hcl` (`providers.scaleway.breakglass.leaves`, root.hcl v4.1.0+). `policy_name` is used exactly as given (unlike `iam-policy`, which appends `-policy`), so an existing policy can be adopted under its current name. The API key's `expires_at` defaults to 30 days after first creation, anchored by `time_static`, as in `iam-api-key`. With `rotation_days`, the key is instead replaced every `rotation_days`, by a `time_rotating` resource, and expires a week after each scheduled rotation (LIB-0024 §4). It's created before the old one is destroyed. That suits a key Terraform hands to other leaves, such as a LIB-0024 workload deployer, where the next plan after a rotation picks up the new key. It doesn't suit a key that is hand-copied into a secrets file, like a spoke's own deployer."
template = "module.html"
in_search_index = true

[extra]
kind = "module"
provider = "scaleway"
module = "terraform-deployer-iam"
latest_version = "0.2.0"
github_url = "https://github.com/noisypigeon/library/tree/main/terraform/scaleway/terraform-deployer-iam"
usage_example = """
module "terraform_deployer_iam" {
  source = "https://noisypigeon.garden/terraform/scaleway/terraform-deployer-iam/v0.1.0"
  name   = "runway-terraform-deploy"

  project_ids             = [local.scaleway_project_id]
  project_permission_sets = ["ObjectStorageFullAccess"]

  organization_id              = local.scaleway_organization_id
  organization_permission_sets = ["IAMManager", "IAMApplicationManager"]

  default_project_id = local.scaleway_project_id
}
"""
versions = [{ version = "0.1.0", path = "terraform/scaleway/terraform-deployer-iam/v0.1.0" }, { version = "0.2.0", path = "terraform/scaleway/terraform-deployer-iam/v0.2.0" }]
+++
