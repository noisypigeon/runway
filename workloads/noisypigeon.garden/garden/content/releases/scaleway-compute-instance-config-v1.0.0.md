+++
title = "scaleway/compute-instance-config v1.0.0"
date = 2026-10-19T12:00:00-07:00
slug = "scaleway-compute-instance-config-v1.0.0"
description = "Write secrets into keyring.toml and stop rendering rclone.conf in compute-instance-config"
+++

This release implements LIB-0018. It renders a cloud-init document that current pigeon-cli can actually load. In v0.1.0, `keyring.toml` was written without secrets, but pigeon-cli now keeps every secret in that file and fails to load an entry without one (pigeon-cli ADR-0135). So every pigeon command on a v0.1.0 instance with a non-empty keyring exited before doing anything.

**`keyring.toml` now carries every secret.** Email identities get `secret` and buckets get `secret_key`, matching pigeon-cli's `Identity` and `BucketConfig`. The file is still written to `/root/.config/pigeon/keyring.toml` at `0600`. Every string value goes through `jsonencode()`, which is also a valid TOML basic string, so a quote, backslash or newline in a password can no longer break the file.

**`/root/.config/rclone/rclone.conf` is no longer rendered.** pigeon-cli writes its own `rclone.conf` beside the keyring (`/root/.config/pigeon/rclone.conf`) at the start of every rclone-backed job and passes `--config` explicitly, so it never read the module's file (pigeon-cli ADRs 0136, 0140, 0145, 0148). The `rclone` package is still installed. Bare `rclone` on an instance now has no remotes. Anything in `post_provision_commands` that ran `rclone ... alias:` against the old file needs `--config /root/.config/pigeon/rclone.conf`, and that file exists only after a pigeon job has run. Calling pigeon is the supported path.

**`PIGEON_SECRET_<ALIAS>` is no longer exported** to `/etc/profile.d/pigeon-env.sh` or `/etc/environment`. With the secret in the keyring, the export only overrode a value with itself and left two more copies of each secret on disk. pigeon-cli still honours the variable if an operator sets it by hand. `PIGEON_LOG_DIR` is unchanged and still gated on `cockpit`.

**Breaking changes to the `keyring` input.** Its object type now mirrors pigeon-cli's schema:

- `kind` accepts `email` and `bucket` only. `kind = "encryption-key"` and `created_at` are removed, because pigeon-cli dropped that entry kind (pigeon-cli ADR-0147).
- `encryption_key_alias` is removed from bucket entries.
- Bucket `provider` is removed. It only fed the old `rclone.conf`, and pigeon-cli always uses `provider = Other`. `provider` now exists only on email entries and is validated against `gmail`, `fastmail`, `icloud`, `proton` and `custom`.
- An email identity's secret is now `secret` rather than `secret_key`. A bucket's is still `secret_key`.
- Required fields are validated per kind. Email entries need `email`, `provider`, `host`, `port` and `secret`. Bucket entries need `endpoint`, `bucket`, `access_key_id` and `secret_key`. A missing secret now fails the plan instead of producing an instance whose pigeon can't load its keyring.

Upgrading changes the rendered document, so `compute-instance` replaces any server built from it.

This was checked by rendering the module from a scratch root with one email entry and one bucket entry, each with quotes, backslashes, `<&>` and a newline in its secret. The whole document parses as YAML, and the extracted `keyring.toml` parses with Python's `tomllib` and returns every secret exactly as given. An empty keyring with no `cockpit` renders the three files empty, as before. Each new validation rejects its bad case: an `encryption-key` entry, an email entry with no `secret`, an email `provider = "Gmail"`, and a bucket entry with no `secret_key`.

The only consumer, runway's `pigeon-cli` leaf, reaches this module through `pigeon-cluster` and has its `module "cluster"` block commented out, so nothing live changes. `pigeon-cluster` v4.0.0 adopts the new shape and repins to this tag in a separate PR.

🤖 Generated with [Claude Code](https://claude.com/claude-code)


PR: https://github.com/noisypigeon/library/pull/78
