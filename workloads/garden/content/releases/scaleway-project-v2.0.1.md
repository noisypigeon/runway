+++
title = "scaleway/project v2.0.1"
date = 2026-10-15T12:00:00-07:00
slug = "scaleway-project-v2.0.1"
description = "Note why the ssh key uses count, not for_each"
+++

`ssh_key` is a single optional object rather than a collection, so `count` is right and the address is always `[0]` when set. The consequence worth writing down is the one a reader won't infer: toggling the input between `null` and a value is a **create/destroy of that address, not a move** — flipping it rotates the registered key rather than renaming one in place.

Comment-only: four lines, zero non-comment additions, `terraform fmt -recursive -check` clean.

### This also re-attempts what #9 was meant to prove

#9 was the comment-only release intended to exercise the module-release chain end to end. It did exercise it — and **found that the chain was broken**. Its `template-release` run was cancelled while pending, because three workflows shared one concurrency group and GitHub allows only one pending run per group. Fixed in #10.

**Re-running #9 could not recover it.** The root `CHANGELOG.md` had since gained #10's line at the same sentinel position, so the rebase conflicted:

```
Auto-merging CHANGELOG.md
CONFLICT (content): Merge conflict in CHANGELOG.md
error: could not apply b28f832... chore: update changelog(s) for PR #9
```

That is the correct outcome twice over: a conflict means two writers touched the same lines and guessing is worse than failing, and because the push happens *before* tagging, the failure left **no tag, no Release and no changelog entry** — a clean no-op rather than a half-applied release. Worth knowing as an operational fact: **a dropped release cannot be recovered by re-run once `main` has moved.** It needs a fresh PR, which is this one.

So the provenance comment from #9 is on `main` but is not in any published version. This PR is the first module release to run against the fixed workflows, and `v2.0.1` will carry both comments.

### What should happen on merge

1. `terraform/scaleway/project/v2.0.1` tagged and released
2. Full body into `terraform/scaleway/project/CHANGELOG.md` under `## [2.0.1]`
3. One root line tagged `[scaleway/project]`, with `root-changelog` standing down
4. `pigeon-dev-pages.yml` dispatched **cross-repo** into `noisypigeon/pigeon.dev`
5. `/modules/scaleway/project/v2.0.1/` live, plus an overview entry and a release post

Steps 4–5 are still unproven: every release so far has been on the `workflows/` track, which cuts no module tag and so never reaches the dispatch. This is the first run that should.


[#11](https://github.com/noisypigeon/pigeon-lib/pull/11)
