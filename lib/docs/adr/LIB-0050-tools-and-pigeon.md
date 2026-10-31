# LIB-0050: lib/ becomes tools/, and the fetch moves to .pigeon/

- **Author**: Willow Graysen ([@noisypigeon](https://github.com/noisypigeon)).
- **Date**: 2026-10-31.
- **Status**: Proposed. Amends:
  - LIB-0047 §3, whose tag names now follow the new paths, and its
    `## Out of scope` line that made renaming a tag track a design boundary;
  - LIB-0047 §5, whose fetch (`.lib-version`, `fetch-lib.sh`, `.lib-src/`)
    moves to `.pigeon/`;
  - LIB-0049 §§1–5, for every path they name;
  - LIB-0001 invariant 2, in name only: a spoke still pins a version, through
    `.pigeon/version`.

  It leaves LIB-0009 alone: no `terraform/` short URL changes.

## Context

LIB-0049 finished the hoist, so `lib/` holds the whole library. Its layout
still records where each part came from, not what it is:

- **Names say where a part came from.** `github-workflows/` and `scripts/` are
  named for the repo directories they left, and `grafana-dashboards/` for a
  product. The reusable CI is three directories (`github-workflows/`,
  `scripts/`, `scripts/policies/`) with nothing grouping them, and the
  `root.hcl` template, which only CI reads, sits apart under `terragrunt/`.
- **The observability stack is named for its first consumer.**
  `observability/pigeon-cli/` is a generic Loki, Grafana, Tempo and Mimir
  (LGTM) stack. Its dashboards sit in a separate tree, `grafana-dashboards/`,
  though the stack mounts them from the same checkout.
- **The theme is named for its tool, not its kind.** `zola-site/` is the one
  static-site theme.
- **The fetch is spread across the root.** A consumer carries three things
  named for "lib": `.lib-version`, `fetch-lib.sh` and the `.lib-src/` clone,
  plus a `LIB_SRC` override. runway, pigeon-cli and both Pages shims all read
  those names.

Tags have always been a unit's path. LIB-0047 kept the old tag names when it
moved the tree under `lib/`, because a consumer had written them down. Here
the paths change meaning, not just prefix. A tag that kept its old name would
no longer say where its unit lives.

## Decision

### 1. The new layout

`lib/` becomes `tools/`:

| Now | Becomes |
| --- | --- |
| `lib/` | `tools/` |
| `lib/terraform/` | `tools/terraform/` |
| `lib/docs/` (records and runbooks) | `tools/docs/` |
| `lib/github-workflows/` | `tools/github/workflows/` |
| `lib/scripts/` | `tools/github/scripts/` |
| `lib/scripts/policies/` | `tools/github/policies/` |
| `lib/terragrunt/root-hcl/` | `tools/github/terragrunt/` |
| `lib/zola-site/` | `tools/static-site/zola/` |
| `lib/observability/pigeon-cli/` | `tools/observability/lgtm-stack/` |
| `lib/grafana-dashboards/pigeon-cli/` | `tools/observability/dashboards/pigeon-cli/` |
| `lib/claude-plugins/` | `tools/claude/plugins/` |

- **Grouped by what each part serves.** `tools/github/` is everything CI runs:
  the reusable workflows, their scripts, the policies and the template that
  `resolve-root-hcl.sh` copies. `tools/observability/` holds the stack and the
  dashboards it renders.
- **Records keep their prefix.** They are still `LIB-NNNN`, now under
  `tools/docs/adr/`.

### 2. Tag tracks follow paths, and each continues its old one

A unit's tag is again its path under `tools/`:

| Old track | New track |
| --- | --- |
| `terraform/<provider>/<module>/` | unchanged |
| `zola-site/` | `static-site/zola/` |
| `terragrunt/root-hcl/` | `github/terragrunt/` |
| `workflows/` | `github/workflows/`, which still covers `github/scripts/` and `github/policies/` |
| `grafana-dashboards/<set>/` | `observability/dashboards/<set>/` |
| `observability/pigeon-cli/` | `observability/lgtm-stack/` |
| `claude-plugins/<plugin>/` | `claude/plugins/<plugin>/` |

- **Versions continue.** LIB-0020's `<!-- continues-from: <tag> -->` marker,
  which today only modules use, works for every track. Each renamed unit's
  `CHANGELOG.md` carries one, naming its old track's last tag, and that
  track's first new tag takes the next number. `github/workflows/v10.0.0`
  follows `workflows/v9.4.3`, for example. The release fails if the named tag
  doesn't exist, as it does for a module today.
- **Old tags are never moved or deleted.** Every pin written against an old
  track keeps resolving: a module source, a `.lib-version`, a marketplace ref,
  a dashboard URL.
- **The per-set predicate reads depth.** `observability/dashboards/<set>/` is
  three levels below `tools/`, while a stack such as
  `observability/lgtm-stack/` is two. So the predicate tells a dashboard set
  from a stack by depth, and gives each its own track.

### 3. Resolvers try the new tag first, then the old

A spoke pins some units by version number alone, and the resolver builds the
tag:

- **`resolve-theme.sh`** builds its tag from a site's
  `[extra].theme_version`. It tries `static-site/zola/vX.Y.Z`, then
  `zola-site/vX.Y.Z`, and archives the theme from whichever path that tag
  holds. The Zola theme name in a site's `config.toml` stays `zola-site`, and
  the theme is still materialized at `themes/zola-site/`. So no site config
  changes.
- **`resolve-root-hcl.sh`** builds its tag from `spoke.hcl`'s
  `root_hcl_version`. It tries `github/terragrunt/vX.Y.Z`, then
  `terragrunt/root-hcl/vX.Y.Z`.
- **A tree is read at the tag's own prefix.** The generator and
  `resolve-root-hcl.sh` read a tag at `tools/` or `lib/`, whichever that tag
  has, instead of at the prefix of the checkout they run in. So an old module
  tag's redirect page keeps naming `//lib/terraform/...`, and a new one names
  `//tools/terraform/...`. Both resolve.

### 4. `.pigeon/` holds the fetch

| Now | Becomes |
| --- | --- |
| `.lib-version` | `.pigeon/version` |
| `fetch-lib.sh` | `.pigeon/tools.sh` |
| `.lib-src/` (gitignored) | `.pigeon/src/` (gitignored) |
| `LIB_SRC` | `PIGEON_SRC` |

- **What `.pigeon/` holds.**
  - `.pigeon/version` names a `github/workflows/` tag.
  - `.pigeon/tools.sh` clones runway into `.pigeon/src/` at that tag.
  - `PIGEON_SRC` points it at a local checkout instead, which must hold
    `tools/github/scripts/`.
- **Every path a consumer runs moves with it.** Scripts run from
  `.pigeon/src/tools/github/scripts/`, and the theme resolver is
  `.pigeon/src/tools/static-site/zola/resolve-theme.sh`. These change with
  them:
  - the defaults of `fetch_script`, `scripts_dir`, `theme_script` and
    `changelog_script`;
  - runway's `prepare_cmd`;
  - the `root.hcl` template, `.mise.toml`'s tasks and `/.gitignore`.
- **Every consumer adopts it.** runway, both Pages shims and pigeon-cli each
  carry a `.pigeon/`. pigeon-cli's `.pigeon/version` must equal its `uses:`
  ref, as its `.lib-version` must today.

### 5. Garden

- **New tags get pages at their own paths:**
  - `noisypigeon.garden/github/workflows/vX.Y.Z/`;
  - `noisypigeon.garden/claude/plugins/<plugin>/vX.Y.Z/`;
  - `noisypigeon.garden/static-site/zola/vX.Y.Z/`.
- **Old tags keep the pages they have,** at `/workflows/`, `/claude-plugins/`
  and `/templates/zola-site/`. Each section index lists both shapes, newest
  first.
- **Module short URLs don't change.** `noisypigeon.garden/terraform/...` is
  LIB-0009's interface, and the module track keeps its name.
- **Dashboard raw URLs** name `tools/observability/dashboards/<set>/` at a new
  tag, and `lib/grafana-dashboards/<set>/` at an old one.

### 6. Everything that names a path moves with it

- **Release automation.** `template-release.yml` changes:
  - its predicates and the table from path to track;
  - its tag-only commits, which now copy `tools/github/workflows/*.yml` and
    `tools/claude/plugins/marketplace.json`, whose plugin sources become
    `./tools/claude/plugins/<plugin>`.

  `root-changelog.yml`'s `releases` job copies every predicate.
- **runway's own workflows:**
  - `precedence` gets `^tools/docs/adr/=adr` and `^tools/docs/runbooks/=docs`;
  - `terragrunt-run`'s discovery filter becomes `!./tools/**`;
  - `module-docs.yml` runs over `tools/terraform/`;
  - `scripts-test` and its layout check watch `tools/github/`.
- **Scripts:**
  - `check-policies.sh` reads its policies from `../policies/`;
  - the generator publishes `schemas/policies/v1.json` from there;
  - `lgtm-stack`'s compose file mounts `../dashboards/pigeon-cli`.
- **Docs.** `CLAUDE.md`, every README and the `release-pr` skill.

### 7. Cutover, in order

Every pinned consumer must keep working throughout. Two lessons from LIB-0047
decide the order:

- **A pure move comes first, and the rewiring second.** In the move, every
  path under `tools/` is new, so it would match every predicate and re-release
  every module.
- **The shims move in the same step as runway's pin.**

| # | Where | Change | Label |
| --- | --- | --- | --- |
| 1 | runway | `docs(adr): LIB-0050 lib/ becomes tools/`: this record | none |
| 2 | runway | Pure move of `lib/` to `tools/` (§1). `template-release.yml`, `root-changelog.yml`'s `releases` job and `module-docs.yml` are set to `workflow_dispatch` for it, so its merge tags nothing. runway's own paths, `precedence` and the layout check, are fixed in the same PR | none |
| 3 | runway | Rewire the CI unit (§§2–4, 6):<br>• script, workflow, policy and template paths;<br>• `.pigeon/` defaults;<br>• the resolvers;<br>• continuation;<br>• the generator's per-tag prefix.<br>The three workflows go back on | `release:major`, giving `github/workflows/v10.0.0` and `github/terragrunt/v10.0.0` |
| 4 | runway | Rewire the theme, the plugins and marketplace, `lgtm-stack` and the dashboards | `release:patch`, giving the first tag of each other renamed track |
| 5 | runway and both shims | runway adopts `.pigeon/` and the new pins: `.pigeon/version`, every `uses:`, `root_hcl_version` with its regenerated `root.hcl`, and the plugin pin. In the same step, each shim's `pages.yml` moves to the new version and adopts `.pigeon/` | none |
| 6 | pigeon-cli | Adopts `.pigeon/` and the new tracks: its `uses:`, marketplace ref and stack checkout. It rides with its next real change, since every pigeon-cli merge releases a crate | n/a |

- **The shims must not lag runway.**
  - **Why.** Each shim's `site-pages.yml` is still at `workflows/v9.3.0`. It
    runs runway's `fetch-lib.sh`, and reads the theme at
    `.lib-src/lib/zola-site/`.
  - **What breaks.** Step 5 removes both from runway. A shim left behind fails
    its next deploy, as garden's did during LIB-0047. The live site stays on
    its last build, so no short URL breaks, but no change ships until the shim
    moves.
- **Step 5 changes the fetcher and the paths it serves together.**
  - **The problem.** An `issue_comment` apply runs `main`'s workflow file with
    the PR's fetcher (LIB-0047's 2026-10-30 amendment, item 3).
  - **The way through.** If step 5 plans any leaf, the owner merges it through
    the ruleset's bypass once every plan reads `No changes.` If it plans none,
    as LIB-0049's pin bumps didn't, it merges like any docs PR.

## Consequences

- **Each part is named for what it is.** The CI unit is one directory, and the
  stack and its dashboards share another.
- **Every consumer repoints once.** That means runway, both shims and
  pigeon-cli, and each one's pins change name as well as number.
- **The tag list doubles for the renamed tracks.** Old tracks stop at their
  last version, and new ones continue the numbers. Anything that lists tags by
  prefix (the generator, the resolvers, a person reading the Releases) has to
  know both names, and the resolvers do.
- **Garden carries two URL shapes** for the theme, the workflows and the
  plugins. The old shape is frozen at its last version.
- **The fetch is one directory.** A consumer's root loses three files named
  for "lib".

## Out of scope

- **Renaming the `LIB-` record prefix, the `library` marketplace or the
  `library` plugin.** Each is a name consumers wrote down, and this record
  changes only paths and tags. This is a design boundary, not a deferral.
- **Renaming a `terraform/` module or its short URL.** Modules keep their
  track and LIB-0009's interface. This is a design boundary, not a deferral.
- **Moving the shims' `pages.yml` into runway.** `actions/deploy-pages`
  deploys only the calling repo's site (DEV-0156). This is a constraint, not a
  deferral.
- **Deleting or rewriting old tags and Releases.** They back every pin that
  hasn't moved. This is a design boundary, not a deferral.

## Verification

1. **The old layout is gone.** `main` has no `lib/`, `.lib-version`,
   `fetch-lib.sh` or `.lib-src/` entry in `/.gitignore`.
2. **Versions continue.** Each renamed track's first tag is the next number
   after its old track's last, and its unit's `CHANGELOG.md` names that tag.
3. **The CI unit releases as before.** `git ls-tree` on the first
   `github/workflows/` tag lists every reusable workflow under
   `.github/workflows/`, and its parent is on `main`.
4. **Old pins still resolve:**
   - `terraform init` of a module at an old tag, through `//lib/...`;
   - `resolve-theme.sh` with an old `theme_version`;
   - `resolve-root-hcl.sh` with an old `root_hcl_version`;
   - pigeon-cli's current marketplace pin.
5. **Every consumer runs from `.pigeon/`.**
   - runway's plan reads its scripts from `.pigeon/src/tools/github/scripts/`.
   - Both shims deploy at the new version.
   - pigeon-cli's first release after step 6 runs green.
6. **Garden serves both shapes:** a new tag's page at its new path, and an old
   tag's page where it was.
