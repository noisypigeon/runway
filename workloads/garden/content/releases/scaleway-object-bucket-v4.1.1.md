+++
title = "scaleway/object-bucket v4.1.1"
date = 2026-10-05T12:00:00-07:00
slug = "scaleway-object-bucket-v4.1.1"
description = "Fix object-bucket ACL/website-config resources to honor project_id"
+++

## Summary
- `scaleway_object_bucket_acl` and `scaleway_object_bucket_website_configuration` each have their own `project_id` argument, independent of the bucket resource's `project_id`, defaulting to the provider's default project when omitted.
- v4.1.0 (#194) set `project_id` on the `scaleway_object_bucket` resource but not on these two new child resources it added — so a bucket created via `exact_name` + `project_id` in a non-default project got its ACL/website-config calls silently scoped to the *wrong* project.
- Confirmed live on `workloads/pigeon.dev/terraform/bucket` (its own dedicated `pigeon-dev` project): the bucket itself created fine, but `PutBucketAcl`/`ListObjects` both failed with deterministic `403 AccessDenied`, unchanged across 4 retries over ~30 minutes — ruling out IAM propagation delay and confirming this project-id mismatch as the actual cause.
- Fix: pass `project_id = var.project_id` through to both child resources. No input/output signature change — restores the module's own already-documented intent that a bucket and its ACL/website-config live in the same project.

## Test plan
- [x] `terraform validate` clean
- [x] `terraform fmt -diff` clean
- [ ] Re-running `terragrunt apply` on #195 against `v4.1.1` succeeds for the `pigeon.dev` bucket's ACL + website-configuration resources

🤖 Generated with [Claude Code](https://claude.com/claude-code)

[#196](https://github.com/noisypigeon/noisypigeon/pull/196)
