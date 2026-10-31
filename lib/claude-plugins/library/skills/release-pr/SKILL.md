---
name: release-pr
description: Use this skill when making a change under lib/ — a lib/terraform/ module, the lib/zola-site/ theme, the lib/terragrunt/root-hcl/ template, a dashboard set, the observability stack, the plugin, lib/scripts/ or a reusable workflow — and getting it merged to main. lib/ is the library, hoisted into runway by LIB-0047; runway and the other consumers take a release by bumping their pin in a separate PR. Covers branching off main, committing, opening the pull request, applying the required release:* label, merging, and syncing local main afterward. Trigger on requests like "open a PR for this", "release this module change", "ship this to main", or "merge this module or theme change".
---

# Releasing a lib/ change

The library's release automation has no human reviewer, and this skill *is*
the PR discipline. Follow it in full for every change under `lib/`, including
trivial ones. The PR title becomes the unit's one-line changelog entry, the PR
body becomes its GitHub Release notes verbatim, and garden's release post
shows that body (LIB-0049 §7). The label drives the version bump. There is no
separate "write good release notes" step later, so get the PR body right the
first time.

A PR that changes nothing under `lib/` and no reusable workflow is a runway
change, not a release. It follows `CLAUDE.md`'s Terraform flow instead.

## Steps

1. **Branch off `main`.**
   ```
   git checkout main
   git pull
   git checkout -b <descriptive-branch-name>
   ```

2. **Make the change and commit it.** Commit messages are for git history.
   The PR title and body are what drive the changelog.

3. **Open the PR with a title and body written for their second life as a
   changelog line and release note**, not just for a reviewer:
   - Title: short, imperative, human-readable. It becomes the unit's
     changelog line verbatim, as `- <title> ([#N](url))` under the version's
     heading, in `lib/terraform/<provider>/<module>/CHANGELOG.md`,
     `lib/zola-site/CHANGELOG.md`, `lib/github-workflows/CHANGELOG.md` and so
     on (e.g. "Add versioning input to object-bucket").
   - Body: full sentences a consumer of the unit would want to read later,
     describing what changed and why it matters to them, not "fixed bug" or a
     raw commit list. `template-release.yml` copies it verbatim into the
     GitHub Release notes on merge, with no editing pass in between, and
     garden's release post shows it.
   ```
   gh pr create --title "<title>" --body "<body>" --base main
   ```

4. **Apply exactly one `release:*` label before merging.** It sets the version
   bump for every unit the PR changes:
   - `release:major`: a breaking change to a unit's inputs, outputs or
     behavior.
   - `release:minor`: a backwards-compatible addition.
   - `release:patch`: a fix or internal-only change. `template-release.yml`
     also defaults to this when no label is present. Apply it explicitly
     anyway: an unlabeled PR is a sign something was skipped, not a
     deliberate patch decision.

   A unit releases when the PR changes:
   - a `.tf` under `lib/terraform/<provider>/<module>/`;
   - `lib/zola-site/templates/`, `static/` or `theme.toml`;
   - `lib/terragrunt/root-hcl/root.hcl` or `secrets-schema.json`;
   - a `lib/grafana-dashboards/<set>/*.json`;
   - anything under `lib/observability/<set>/` or `lib/claude-plugins/<set>/`
     other than its README or CHANGELOG;
   - `lib/scripts/`, or a reusable workflow in `lib/github-workflows/`
     (LIB-0049). `.github/workflows/` holds only runway's own workflows, and
     changing one releases nothing.

   Anything else under `lib/`, such as a README- or CHANGELOG-only change,
   needs no label: nothing is tagged. It still gets one line in the root
   `CHANGELOG.md` from `root-changelog.yml` (DEV-0160), so the PR title still
   has a second life as published copy.
   ```
   gh pr edit <pr-number> --add-label "release:patch"
   ```

5. **Merge the PR** once ready. There is no separate review gate, so this is
   the discipline checkpoint:
   ```
   gh pr merge <pr-number> --squash --delete-branch
   ```
   Merging triggers `template-release.yml`. It tags each changed unit, updates
   its `CHANGELOG.md` and the root one, cuts a GitHub Release, then dispatches
   `garden-generate.yml` in this repo. That regenerates noisypigeon.garden's
   pages under `workloads/noisypigeon.garden/garden/` and commits them, which
   deploys them through `sites.yml` and the `noisypigeon/noisypigeon.garden`
   shim. A `lib/terraform/` change also triggers `module-docs.yml`, which
   regenerates the module's `README.md` input/output table. A theme release
   additionally dispatches `pages.yml` in `noisypigeon/noisypigeon.com`. None
   of these need triggering by hand.

   Watch the noisypigeon.com dispatch: it's the one that crosses a repo, and
   it fails if `BOT_GITHUB_TOKEN` loses `actions: write` there. A release whose
   garden generation fails shows up as a tagged, released version whose short
   `noisypigeon.garden/terraform/...` URL 404s, not as an obviously broken
   release.

6. **Sync local `main`.** That means pulling the automation's commits, not
   re-running any workflow:
   ```
   git checkout main
   git pull
   ```
   This picks up the squash-merge commit and the automated changelog and docs
   commits on top of it.

7. **Bump the consumers, each in its own PR.** A consumer takes a release only
   by moving its pin (LIB-0001 invariant 2), and only once garden has deployed
   the release, so its short URL resolves before `terragrunt init` fetches
   it:
   - **runway itself:** a module's `source` in a hand-written leaf, a
     workload's module version, `.lib-version` for the workflows track,
     `root_hcl_version` in `spoke.hcl`, or a site's `theme_version` in its
     `config.toml`;
   - **the shims and pigeon-cli,** at the `@workflows/vX.Y.Z` they call.
