+++
title = "cloudflare/bucket v1.0.0"
date = 2026-10-15T12:00:00-07:00
slug = "cloudflare-bucket-v1.0.0"
description = "Make cloudflare/bucket EU-only, with Standard storage by default (LIB-0006)"
+++

`cloudflare/bucket` now puts every R2 bucket in the EU jurisdiction and stores objects as `Standard` unless told otherwise. [LIB-0006](https://github.com/noisypigeon/pigeon-lib/blob/main/docs/adr/LIB-0006-cloudflare-buckets-are-eu-only.md) records why.

### Always the EU jurisdiction

Every bucket is created with `jurisdiction = "eu"`, which Cloudflare enforces: the bucket's data stays in the EU. The `jurisdiction` input is gone, so a bucket outside the EU can't be made through this module.

### No location hint

The `location` input is removed. A location hint is best effort and isn't always respected, and under the EU jurisdiction it adds nothing. The provider still reports the bucket's actual location as a computed attribute.

### `storage_class` defaults to `Standard`

`storage_class` now defaults to `"Standard"` and can't be null. `InfrequentAccess` is still accepted.

### The endpoint is always the EU one

The `endpoint` output is always `https://<account_id>.eu.r2.cloudflarestorage.com`. An EU bucket isn't reachable through the default endpoint, so point S3 clients such as rclone at this output.

### Breaking

Passing `location` or `jurisdiction` is now an "Unsupported argument" error. No leaf calls this module yet, so nothing needs migrating.

```hcl
module "bucket" {
  source = "https://pigeon.dev/modules/cloudflare/bucket/v1.0.0"

  account_id  = local.cloudflare_account_id
  name_prefix = "example-com"
  name_suffix = "assets"
}
```

Verified with `terraform validate`, and with plans against a scratch root (`cloudflare/cloudflare` 5.28.0). The plans covered both naming schemes, an explicit `InfrequentAccess` and a `null` storage class. Each guard was also checked to fail as expected.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

[#37](https://github.com/noisypigeon/pigeon-lib/pull/37)
