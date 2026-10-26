+++
title = "scaleway/terraform-deployer-iam v0.2.0"
date = 2026-10-20T12:00:00-07:00
slug = "scaleway-terraform-deployer-iam-v0.2.0"
description = "Rotate the deployer API key every rotation_days"
+++

`terraform-deployer-iam` gains an optional `rotation_days` input (LIB-0024 §4).

- **With it set,** a `time_rotating` resource replaces the API key every `rotation_days`. The new key is created before the old one is destroyed, and each key expires a week after its scheduled rotation, so a month in which nothing plans doesn't strand its users. It's meant for a key Terraform hands to other leaves, such as a LIB-0024 workload deployer, which pick up the new key on the next plan.
- **Without it,** nothing changes in behaviour: the key expires 30 days after it was first created, and an explicit `expires_at` still wins. A caller upgrading from v0.1.0 does see one new resource in its plan, `terraform_data.rotation`, which carries the rotation trigger and does nothing while `rotation_days` is unset.

`rotation_days` must be positive.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

[#113](https://github.com/noisypigeon/library/pull/113)
