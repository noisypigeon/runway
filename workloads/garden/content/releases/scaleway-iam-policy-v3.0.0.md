+++
title = "scaleway/iam-policy v3.0.0"
date = 2026-10-03T12:00:00-07:00
slug = "scaleway-iam-policy-v3.0.0"
description = "Continue this module's version lineage under the templates/terraform prefix"
+++

DEV-0110 moved `modules/` to `templates/terraform/` and cut one tag per module
under the new prefix to continue each module's version lineage there. This
version's own GitHub Release describes it as "Bookkeeping only -- same tree
content as the move commit, no resource/behavior change", following the same
pattern DEV-0093 used for its own prior move. The tag and its Release were created
with PR #144; only the changelog entry was missed, which is what this backfills by
hand, since the automation writes entries from PR bodies alone.

**No behaviour change.** This version's `iam_policy.tf`, `inputs.tf`, `outputs.tf` and `versions.tf` are byte-identical to
`v2.0.1`'s. The major bump records a change to the module's *source path* only:
a module's source path is part of its public interface, so relocating it is
breaking for every consumer regardless of whether any resource definition changed
(DEV-0093, DEV-0110).

Consumers pinning `v2.0.1` and `v3.0.0` resolve identical module content; the
difference is which repo and tag the short URL resolves to.

[#144](https://github.com/noisypigeon/noisypigeon/pull/144)
