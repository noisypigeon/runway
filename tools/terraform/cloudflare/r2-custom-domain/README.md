# r2-custom-domain

One R2 bucket served on one hostname of a Cloudflare zone
(`cloudflare_r2_custom_domain`), for a site workload's
`deployments.cloudflare` (LIB-0051 §2).

- **The zone is looked up by its apex,** as `dns-record` does (LIB-0011), so a
  leaf needs no zone ID.
- **The bucket is addressed in R2's `eu` jurisdiction,** where every family
  bucket is (LIB-0006). There's no input to change it.
- **It is one resource.** A bucket on its apex and on `www` is two instances,
  composed beside `cloudflare/bucket` as LIB-0038 composes deployers.

## Usage

```hcl
module "custom_domain" {
  source = "https://noisypigeon.garden/terraform/cloudflare/r2-custom-domain/v0.1.0"

  account_id  = local.cloudflare_account_id
  zone        = "example.com"
  bucket_name = "example.com"
  domain      = "example.com"
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
