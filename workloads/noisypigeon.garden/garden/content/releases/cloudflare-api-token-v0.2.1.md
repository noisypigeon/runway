+++
title = "cloudflare/api-token v0.2.1"
date = 2026-10-30T12:00:00-07:00
slug = "cloudflare-api-token-v0.2.1"
description = "fix(lib-0051): name the nearest permission groups when api-token can't find one"
+++

**Why this PR changed.** It first proposed garden on R2 at a test host (LIB-0051 §4 step 1). That plan failed on the noisypigeon.garden zone's token: "No permission group named Transform Rules Write at the scope its policy needs". The group name `root.hcl` gives the zone's `sites-root` ruleset is wrong. Nothing here says which name is right. This session can only push to this one branch, so the PR now carries the fix that makes the error say, and the garden change is reverted. It comes back in its own PR once the correct group name is known.

**`cloudflare/api-token`.** When a permission group name doesn't resolve at its policy's scope, the error now also lists the groups that share a word of four letters or more with it ("Read" and "Write" don't count), each with its scopes. For example:

> No permission group named Transform Rules Write at the scope its policy needs. Groups with a word in common: … (api.account.zone); …

Nothing changes when every name resolves. Workload leaves float to the newest module version, so the next plan that hits the bad name prints the candidates.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

https://claude.ai/code/session_015XFA1nJsR1vQPyo6wYwWSk

PR: https://github.com/noisypigeon/runway/pull/169
