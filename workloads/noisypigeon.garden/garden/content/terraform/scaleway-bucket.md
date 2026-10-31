+++
title = "scaleway/bucket"
description = "A Scaleway Object Storage bucket (`scaleway_object_bucket`) with a randomized name suffix (or an `exact_name` override for buckets whose name must match something external, e.g. a custom domain), versioning, a standard/glacier storage-class toggle implemented via an immediate lifecycle transition, and optional static-website hosting (`enable_website`) plus public-read ACL (`enable_public_read`)."
template = "module.html"
in_search_index = true

[extra]
kind = "module"
provider = "scaleway"
module = "bucket"
latest_version = "5.0.0"
github_url = "https://github.com/noisypigeon/runway/tree/main/tools/terraform/scaleway/bucket"
usage_example = ""
versions = [{ version = "5.0.0", path = "terraform/scaleway/bucket/v5.0.0" }]
+++
