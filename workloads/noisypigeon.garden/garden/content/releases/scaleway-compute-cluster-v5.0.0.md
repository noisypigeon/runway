+++
title = "scaleway/compute-cluster v5.0.0"
date = 2026-10-20T12:00:00-07:00
slug = "scaleway-compute-cluster-v5.0.0"
description = "Rename scaleway/pigeon-cluster to compute-cluster and scaleway/object-bucket to bucket"
+++

This module is renamed by LIB-0020: `scaleway/pigeon-cluster` is now `scaleway/compute-cluster`, matching the `compute-instance` family it composes, and `scaleway/object-bucket` is now `scaleway/bucket`, matching `cloudflare/bucket` and `backblaze/bucket`. The code is unchanged from the old module's last release (`pigeon-cluster` v4.0.0, `object-bucket` v4.2.0), with the same inputs, outputs and resource addresses. This is a major release only because the source URL changes.

To move a consumer, change its `source =` to `https://noisypigeon.garden/terraform/scaleway/compute-cluster/v5.0.0` or `…/scaleway/bucket/v5.0.0`. A leaf already on the old module's latest version should plan no changes. Every old version's short URL keeps resolving, and the old name gets no further releases. Its history up to the rename stays in its own CHANGELOG.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

PR: https://github.com/noisypigeon/library/pull/85
