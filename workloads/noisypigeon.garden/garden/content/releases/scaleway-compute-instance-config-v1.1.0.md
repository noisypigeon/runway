+++
title = "scaleway/compute-instance-config v1.1.0"
date = 2026-10-28T12:00:00-07:00
slug = "scaleway-compute-instance-config-v1.1.0"
description = "Let compute-instance-config take keyring fields from wiring and secrets"
+++

`compute-instance-config` v1.1.0 adds two inputs that fill in a keyring entry's fields by alias. A workload's config leaf ([LIB-0043](https://github.com/noisypigeon/library/blob/main/docs/adr/LIB-0043-workload-compute-kinds.md) §4) needs them, because a keyring entry's bucket name and credentials come from other leaves' outputs, and its secrets come from `secrets.workload.yaml`. Neither fits a literal `keyring` list.

- **`keyring_wiring`**, a sensitive map from alias to `{ bucket, access_key_id, secret_key }`, all optional. A null field leaves the entry's own value. It's what a stub fills from a bucket leaf's name and an API key leaf's credentials.
- **`keyring_secrets`**, a sensitive map from alias to a map of string fields: `email`, `host`, `secret`, `endpoint`, `bucket`, `access_key_id` or `secret_key`. Any other field is refused. It's what root.hcl fills from resolved `secretRef`s.

Each entry is `keyring`'s, then its wiring, then its secrets, merged by alias. Naming an alias that `keyring` doesn't have fails the plan.

**Where the required-field checks run moves.** An email entry still needs `email`, `provider`, `host`, `port` and `secret`, and a bucket entry still needs `endpoint`, `bucket`, `access_key_id` and `secret_key`, with the same messages. They're now checked on the merged entries, as preconditions on the `cloud_init` output, instead of as validations on `keyring`, since a field may arrive through either new input. A caller that sets neither input sees the same errors as before.

Without either input, the module renders exactly what v1.0.0 renders. Verified by applying v1.0.0 and v1.1.0 side by side in a scratch root: the documents are identical with a complete `keyring`, and identical again when the same values arrive split across `keyring`, `keyring_wiring` and `keyring_secrets`. A missing `secret`, and an unknown alias in `keyring_secrets`, each failed the plan with its message.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

PR: https://github.com/noisypigeon/library/pull/222
