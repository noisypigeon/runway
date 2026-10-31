+++
title = "backblaze/bucket"
description = "A private Backblaze B2 bucket (`b2_bucket`) with a randomized name suffix (B2 bucket names are globally unique across all accounts, like S3), or exactly `exact_name` when the name must match something external, such as a backup bucket named after the R2 bucket it mirrors (LIB-0016 §2). Set either `exact_name`, or both `name_prefix` and `name_suffix`. Always `bucket_type = \"allPrivate\"` — no public-bucket override. An optional `description` is stored in the bucket's `bucket_info` metadata."
template = "module.html"
in_search_index = true

[extra]
kind = "module"
provider = "backblaze"
module = "bucket"
latest_version = "0.2.0"
github_url = "https://github.com/noisypigeon/runway/tree/main/tools/terraform/backblaze/bucket"
usage_example = ""
versions = [{ version = "0.1.0", path = "terraform/backblaze/bucket/v0.1.0" }, { version = "0.1.1", path = "terraform/backblaze/bucket/v0.1.1" }, { version = "0.2.0", path = "terraform/backblaze/bucket/v0.2.0" }]
+++
