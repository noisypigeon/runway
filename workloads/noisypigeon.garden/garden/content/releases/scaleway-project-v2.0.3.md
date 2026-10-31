+++
title = "scaleway/project v2.0.3"
date = 2026-10-16T12:00:00-07:00
slug = "scaleway-project-v2.0.3"
description = "Drop pigeon.dev from comments and docs"
+++

Comments and docs across the hub now describe the current architecture only. `pigeon.dev` is gone from them: the site repo is `noisypigeon/garden`, and module sources are `https://noisypigeon.garden/terraform/<provider>/<module>/vX.Y.Z`.

- **`terragrunt/root-hcl`:** the template's header drops how it was generalized from the monorepo's per-domain roots, and its example secret is a real current one. Only comments change, so every leaf renders exactly as it did under v2.2.0, and a spoke can take this version as a no-op.
- **`scaleway/project`:** the header comment drops the module's relocation history. No inputs, outputs or resources change.
- **`generate-module-redirects.sh`:** a comment change only.
- **Docs:** `CLAUDE.md`, `terraform/README.md`, `terragrunt/root-hcl/README.md`, `zola-site/README.md` and the `release-pr` skill name `noisypigeon/garden` and the current host, without the pigeon.dev history.
- **LIB-0009** gets an amendment line. `pigeon.dev` redirects to `https://noisypigeon.com`, not the garden (noisypigeon/noisypigeon.com#33).

🤖 Generated with [Claude Code](https://claude.com/claude-code)


PR: https://github.com/noisypigeon/pigeon-lib/pull/55
