+++
title = "scaleway/pigeon-cluster v4.0.0"
date = 2026-10-19T12:00:00-07:00
slug = "scaleway-pigeon-cluster-v4.0.0"
description = "Take pigeon-cli's keyring shape and repin compute-instance-config to v1.0.0"
+++

`pigeon-cluster`'s keyring inputs now take pigeon-cli's own `keyring.toml` shape, and both of its `compute-instance-config` calls (per job and for the bastion) repin from `v0.1.0` to `v1.0.0` ([LIB-0018](https://github.com/noisypigeon/library/blob/main/docs/adr/LIB-0018-pigeon-instances-use-pigeon-cli-keyring-and-rclone-config.md) §4). A job instance built from this release can load its keyring and run pigeon. No instance built from `v3.x` with a keyring could, because pigeon-cli no longer read the shape that version wrote.

### What changes in `cluster_config.shared_keyring` and `jobs[*].keyring`

Both stay `map(object(...))` keyed by alias, and the map key is still the alias.

- **`kind` accepts `email` and `bucket` only.** `kind = "encryption-key"` and its `created_at` field are removed.
- **An email entry's secret is `secret`**, matching pigeon-cli's `Identity`. Email entries require `email`, `provider`, `host`, `port` and `secret`, and `provider` must be one of `gmail`, `fastmail`, `icloud`, `proton` or `custom`.
- **Bucket entries lose `provider` and `encryption_key_alias`.** A bucket keeps `endpoint`, `bucket`, `access_key_id` and `secret_key`. As before (DEV-0144), a bucket that omits `access_key_id`/`secret_key` gets the job's own API key.
- **A missing required field fails the plan.** `compute-instance-config` v1.0.0 validates each kind's required fields, so an incomplete entry no longer produces an instance whose pigeon can't load its keyring.

Terraform's type conversion drops an attribute the object type doesn't declare, so a leftover bucket `provider` or `encryption_key_alias` is ignored silently rather than rejected. Remove them anyway.

### What changes on the instances

`compute-instance-config` v1.0.0 writes every secret into `/root/.config/pigeon/keyring.toml` (0600). It no longer renders `/root/.config/rclone/rclone.conf` or exports `PIGEON_SECRET_<ALIAS>`. pigeon generates its own `rclone.conf` at `/root/.config/pigeon/rclone.conf` from the bucket entries each time a job runs. A bare `rclone ... alias:` in `job_commands`, or in a bastion shell, finds no remotes; pass `--config /root/.config/pigeon/rclone.conf`, or call pigeon.

The rendered cloud-init changes, so every server is replaced on upgrade. Jobs self-delete anyway, so in practice that's the bastion.

### Re-enabling runway's pigeon-cli leaf

runway's `terraform/scaleway/pigeon-cluster/pigeon-cli/` is this module's only consumer, and its `module "cluster"` block is commented out, so nothing live changes. When it's re-enabled, it needs to:

- pin `https://noisypigeon.garden/terraform/scaleway/pigeon-cluster/v4.0.0` or later, not the `v3.0.1` its comment names;
- remove `provider = "Scaleway"` from `shared_keyring.reports`, which this version no longer reads;
- move the commented job commands from `--source-path`/`--destination-path` to `--source-bucket`/`--destination-bucket` (pigeon-cli ADR-0136). Those flags were stale before this release.

Verified with `terraform init`, `validate` and `plan` in a scratch root against this module with the bastion enabled, a shared bucket entry with no credentials and a job email entry: both nested `compute-instance-config` sources resolved to `v1.0.0` from `noisypigeon.garden`, and the plan came to 20 resources to add. Dropping the email entry's `secret` failed the plan with `compute-instance-config`'s required-field validation.

🤖 Generated with [Claude Code](https://claude.com/claude-code)


PR: https://github.com/noisypigeon/library/pull/79
