+++
title = "scaleway/project v2.0.2"
date = 2026-10-16T12:00:00-07:00
slug = "scaleway-project-v2.0.2"
description = "Use noisypigeon.garden/terraform/ short URLs"
+++

Module short URLs now live at `https://noisypigeon.garden/terraform/<provider>/<module>/vX.Y.Z` ([LIB-0009](https://github.com/noisypigeon/pigeon-lib/blob/main/docs/adr/LIB-0009-terraform-short-urls-move-to-noisypigeon-garden.md)). The old `https://pigeon.dev/modules/...` URLs no longer resolve.

- **`scaleway/pigeon-cluster`** sources its ten nested modules from the new URLs, at the same versions as before. Every earlier `pigeon-cluster` tag nests `pigeon.dev` URLs and can no longer `terraform init`, so a consumer of this module should pin this release or later. Nothing else about its inputs, outputs or resources changes.
- **`scaleway/project`** changes only a comment, which names the new URL.
- **Docs:** every module README's usage example, `terraform/README.md`, the root `README.md` and `CLAUDE.md`, `zola-site/README.md` and the `release-pr` skill use the new host.

Verified by running `terraform init` and `terraform validate` on `pigeon-cluster`: all ten nested sources downloaded from `noisypigeon.garden`, and the configuration is valid.

🤖 Generated with [Claude Code](https://claude.com/claude-code)


[#53](https://github.com/noisypigeon/pigeon-lib/pull/53)
