+++
title = "scaleway/iam-api-key v0.3.0"
date = 2026-10-26T12:00:00-07:00
slug = "scaleway-iam-api-key-v0.3.0"
description = "Add rotation_days to iam-api-key"
+++

`iam-api-key` can now rotate its key, exactly as `terraform-deployer-iam` does (LIB-0038 §2). Set `rotation_days` and a `time_rotating` replaces the key every that many days, creating the new key before destroying the old one, and each key expires a week after its scheduled rotation. An explicit `expires_at` still wins. Unset, the key keeps the 30-day expiry it has today.

The resources carry the same addresses as `terraform-deployer-iam`'s key: `time_static.created`, `time_rotating.key[0]`, `terraform_data.rotation` and `scaleway_iam_api_key.api_key`. A deployer's key can then move from the bundle into its own `iam-api-key` leaf with its rotation timestamp, with nothing replaced and no early rotation.

`terraform_data.rotation` always exists, since `replace_triggered_by` can't name a resource that may have no instances. An existing key that takes this version without `rotation_days` plans one `terraform_data` create and no change to the key itself.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

PR: https://github.com/noisypigeon/library/pull/194
