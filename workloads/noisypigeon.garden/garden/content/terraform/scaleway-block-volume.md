+++
title = "scaleway/block-volume"
description = "A Scaleway Block Storage volume (`scaleway_block_volume`) with a randomized name suffix. Minimal interface — `size` (required, renamed from the resource's `size_in_gb`), `iops` (defaults to `15000`), `project_id` (required), no snapshots, tags, or zone overrides yet."
template = "module.html"
in_search_index = true

[extra]
kind = "module"
provider = "scaleway"
module = "block-volume"
latest_version = "4.0.0"
github_url = "https://github.com/noisypigeon/runway/tree/main/tools/terraform/scaleway/block-volume"
usage_example = ""
versions = [{ version = "3.0.0", path = "terraform/scaleway/block-volume/v3.0.0" }, { version = "4.0.0", path = "terraform/scaleway/block-volume/v4.0.0" }]
+++
