# LIB-0049: Finish the hoist: lib/ holds the whole library

- **Author**: Willow Graysen ([@noisypigeon](https://github.com/noisypigeon)).
- **Date**: 2026-10-31.
- **Status**: Proposed. Amends:
  - LIB-0047 §1: its path table, its "reusable workflows stay at the root",
    "so does the marketplace", "`lib/CLAUDE.md` is a nested `CLAUDE.md`" and
    "runbooks sit beside `adr/`" bullets;
  - LIB-0017, whose record home moves from `adr/` to `lib/docs/adr/`;
  - DEV-0155 as LIB-0047 applied it: the reusable workflows' source leaves
    `.github/workflows/`, and only their released copies live there;
  - DEV-0160, for the format of a unit's own `CHANGELOG.md`.

  Makes LIB-0048 §2's split between runway's own jobs and the reusable ones
  structural.

## Context

LIB-0047 moved the library under `lib/`, except for what it took the platform
to pin to a repo's root. After the hoist, these library parts still sit
outside `lib/`:

| Part | Where it is | Why LIB-0047 left it |
| --- | --- | --- |
| The reusable workflows and their `CHANGELOG.md` | `.github/workflows/` | GitHub calls a reusable workflow only from there (DEV-0155) |
| The `release-pr` skill | `.claude/skills/release-pr/` | Claude Code reads project skills only from there |
| The `library` marketplace | `.claude-plugin/marketplace.json` | A `github` marketplace source reads it from the repo root |
| Decision records, with `archive/` | `adr/` | Records were thought of as runway's |
| Runbooks | `runbooks/` | "They're about operating a spoke" |
| An ignore file | `lib/.gitignore` | It came with the tree |
| The library's guide | `lib/CLAUDE.md` | It came with the tree, as a nested guide |

Each of these has a cost now:

- **Two kinds of workflow share one directory.** `template-release.yml` has to
  open every changed `.yml` and look for `workflow_call` to tell a reusable
  from one of runway's callers (LIB-0047's 2026-10-30 amendment, item 2).
  LIB-0048 §2 had to audit both kinds as two lists in one directory. A file
  gaining or losing `workflow_call` silently changes which track owns it.
- **The library isn't served from garden.** Modules, schemas and theme
  versions each have a short URL on `noisypigeon.garden` (LIB-0009, LIB-0035).
  The workflows and the plugins are consumed by a raw GitHub path, and the
  `release-pr` skill isn't versioned at all. runway runs whatever skill is on
  its own `main`, against invariant 2 of LIB-0001.
- **The two guides have drifted.** `lib/CLAUDE.md` still says "a spoke never
  writes a tag", which LIB-0047 §4 amended. It counts five releasable units,
  where there are seven tracks, and cites `#301` without its repo. runway's
  `CLAUDE.md` still says "this repo cuts no releases and has no `release:*`
  labels", which stopped being true at the hoist. Each guide is half the
  picture, and neither is right.
- **Two ignore files say the same thing.** Every pattern in `lib/.gitignore`
  is already in `/.gitignore`.
- **Unit changelogs are a second copy of each PR body.** A unit's
  `CHANGELOG.md` holds its PR body verbatim, so it runs to thousands of lines.
  `.github/workflows/CHANGELOG.md` is over 1,500. The same text is already the
  GitHub Release's notes and the PR's body. Everywhere else in runway, a
  changelog is one line per PR (DEV-0160).

**GitHub's constraint stands.** A `uses:` takes
`{owner}/{repo}/.github/workflows/{file}@{ref}`, or `./.github/workflows/{file}`
in the same commit, and nothing else. It can't take a URL, and it reads only
`.github/workflows/` at the ref it is given. But nothing requires that ref to
be on `main`. A tag can name a commit that no branch contains, and GitHub
resolves a workflow there like at any other ref.

## Decision

### 1. `lib/github-workflows/` holds the reusable workflows

- **The source moves.** Every workflow with a `workflow_call` trigger moves
  from `.github/workflows/` to `lib/github-workflows/`, under the same file
  name. Their `CHANGELOG.md` moves with them.
- **`.github/workflows/` on `main` is only runway's own.** That means runway's
  callers, `template-release.yml`, `root-changelog.yml`, `module-docs.yml` and
  `scripts-test.yml`. No file there has a `workflow_call` trigger, and
  `scripts-test` fails if one does.
- **The `workflows` predicate is a path again.** A `workflows` release needs a
  changed `lib/github-workflows/*.yml` or anything under `lib/scripts/`. The
  `workflow_call` check is dropped. Its twin in `root-changelog.yml`'s
  `releases` job changes in the same PR, as every predicate does.
- **Linting follows the source.** `scripts-test`'s workflow lint covers
  `lib/github-workflows/` as well as `.github/workflows/`.

### 2. A `workflows/` tag names a release commit off `main`

- **The commit.**
  1. `template-release.yml` writes the changelog commit to `main`, as today.
  2. It then makes one more commit on top of that one. This commit copies every
     `lib/github-workflows/*.yml` into `.github/workflows/`, and nothing else.
  3. It tags that commit `workflows/vX.Y.Z` and pushes the tag only. The
     commit's parent is on `main`, and the commit itself never is.
- **Every `uses:` line still resolves.**
  `noisypigeon/runway/.github/workflows/<w>.yml@workflows/vX.Y.Z` names the
  copy in the tagged commit. `site-pages.yml`'s nested
  `./.github/workflows/zola-site-pages.yml` resolves in that same commit. No
  caller changes anything but its version.
- **`fetch-lib.sh` is unaffected.** `.lib-version` names a `workflows/` tag,
  and the tagged commit holds all of `main`'s tree at the release, `lib/scripts/`
  included.
- **A name may not collide.** The release fails before tagging if a file in
  `lib/github-workflows/` has the same name as one of runway's own workflows.
  LIB-0047 §1's two renamed callers are why none collides today.
- **The push needs `workflows` scope.** GitHub refuses a push that changes
  `.github/workflows/` from `GITHUB_TOKEN`. The tag push uses
  `BOT_GITHUB_TOKEN`, which must carry the `workflows` permission on runway.
  That is checked before step 2 of the cutover below.
- **Tag pushes still fire nothing.** No workflow in `lib/github-workflows/` has
  a `push` trigger, so the copies run only when they are called. LIB-0047's
  2026-10-28 amendment found the same for tags.
- **Old tags are untouched.** Every `workflows/` tag up to the last one cut
  before this change keeps its commit on `main`, and keeps resolving.

### 3. garden serves the workflows

- **Each version gets a page.** `garden-generate` emits
  `noisypigeon.garden/workflows/vX.Y.Z/`, one page per `workflows/` tag, and an
  index at `noisypigeon.garden/workflows/`. A version's page lists each
  workflow with:
  - the exact `uses:` line to write;
  - its `workflow_call` inputs, outputs and secrets, read from the file at the
    tag;
  - a link to the file at the tag, and to the Release.
- **The pages are generated, like `theme-versions/`.** They are committed
  under the garden workload by the same `garden-generate.yml` run that writes
  the module pages, and never hand-edited.
- **The URL is how a caller finds the version.** A caller copies its `uses:`
  line from the version's page, since GitHub can't read the page itself. The
  `CLAUDE.md`, the README and the `release-pr` skill name the URL, not the raw
  path.

### 4. The skill and the marketplace go the same way

- **`release-pr` becomes a plugin.**
  - The skill moves from `.claude/skills/release-pr/` to a new plugin,
    `lib/claude-plugins/library/skills/release-pr/`.
  - It is released as `claude-plugins/library/vX.Y.Z`, like `pigeon-cli`.
  - runway enables `library@library` through a pinned marketplace in a new
    `.claude/settings.json`. From then on `.claude/` holds only runway's own
    config. A change to the skill reaches runway only when a PR bumps that pin.
- **The marketplace moves under `lib/`.**
  - `.claude-plugin/marketplace.json` moves to
    `lib/claude-plugins/marketplace.json`.
  - garden publishes one marketplace per plugin release, at
    `noisypigeon.garden/claude-plugins/<plugin>/vX.Y.Z/marketplace.json`. Its
    one plugin's source is runway at that plugin's tag, under
    `lib/claude-plugins/<plugin>/`.
  - A consumer adds the marketplace by that URL. Its name stays `library`, so
    `<plugin>@library` doesn't change.
- **Old pins keep working.** pigeon-cli pins the `github` marketplace at
  `claude-plugins/pigeon-cli/v1.0.1`, and that tag's tree still has the root
  `.claude-plugin/marketplace.json`. pigeon-cli moves to the URL with its next
  real change.
- **To check first.** Before step 4 of the cutover, check that Claude Code
  loads a marketplace from a URL whose plugin source is a git repo at a ref,
  under a subdirectory. If it can't, the per-version marketplace is put on a
  tag-only commit at the root, exactly as §2 does for workflows, and garden's
  page links to that commit's raw file.

### 5. Records and runbooks move to `lib/docs/`

- **The move.** `adr/`, with `archive/`, becomes `lib/docs/adr/`. `runbooks/`
  becomes `lib/docs/runbooks/`. Numbering, file names and IDs don't change.
  The library is where the family's decisions have been filed since LIB-0017,
  and runbooks serve any spoke.
- **What moves with them.**
  - runway's root-changelog `precedence` gains `^lib/docs/adr/=adr` and
    `^lib/docs/runbooks/=docs`, ahead of `^lib/=lib`. A record's PR still gets
    the `adr` tag.
  - `adr-issue.sh`'s default record path.
  - Relative links between records, and the `CLAUDE.md` and skill text.
- **Nothing releases.** `lib/docs/` is not a unit, and no predicate matches
  it.
- **Old links aren't rewritten.** Releases, PRs, issues and pigeon-cli's
  records that link `adr/...` on `main` will 404 after the move, and a
  permalink at a commit keeps working. As LIB-0047 says, records cite the old
  location forever.

### 6. One `.gitignore` and one `CLAUDE.md`

- **`lib/.gitignore` is deleted.** Its five patterns (`.DS_Store`, `*.env`,
  `.terraform.lock.hcl`, `.terraform/`, `*.tfstate*`) are already in
  `/.gitignore`, and nothing new is added.
- **`lib/CLAUDE.md` is merged into `/CLAUDE.md`,** which is the one guide
  afterwards.
  - **What it carries:** the units and their tracks, the consumption and
    release contract, filing a record, the runbooks, and the dev cycle for a
    PR in and out of `lib/`.
  - **What it corrects:**
    - "A spoke never writes a tag" becomes LIB-0047 §4's rule: runway writes
      the lib tracks' tags, and no other tag.
    - The seven tracks are named: a module, the theme, `workflows`, the
      template, a dashboard set, an observability set and a plugin.
    - `#301` becomes `noisypigeon/library#301`.
    - "This repo cuts no releases and has no `release:*` labels" becomes the
      `release-pr` rule for a PR under `lib/`.
  - **It stays short.** Module-level detail stays in `lib/README.md` and
    `lib/terraform/README.md`, and the guide points there.

### 7. A unit's changelog is one line per release

- **The format.** `template-release.yml` writes each unit's entry as a version
  heading and one line:

  ```markdown
  ## [X.Y.Z] - YYYY-MM-DD

  - <PR title> ([#N](<PR URL>))
  ```

  The `## [X.Y.Z] - date` heading stays, because track continuation reads the
  first one to find a renamed track's last tag. This format applies to every
  unit's `CHANGELOG.md` and to `lib/github-workflows/CHANGELOG.md`.
- **The long form lives in the Release.** A Release's notes are still the PR
  body, verbatim, and the PR keeps it. The `release-pr` skill's "the body
  becomes the changelog entry and the Release notes" changes to "the title
  becomes the changelog line, and the body becomes the Release notes".
- **garden's release posts read the Release first.**
  `generate-module-redirects.sh` builds a release post from the module's
  `CHANGELOG.md` on `main` today. It changes to read the body from the Release
  for that tag, and to fall back to the `CHANGELOG.md` entry for a tag with no
  Release. That lands **before** the backfill, or every post loses its body.
- **Every existing entry is backfilled.**
  - Each long entry in each unit's `CHANGELOG.md`, and in the workflows'
    changelog, is rewritten to its one line.
  - The line is the PR title. Where there is no PR, which is true of the tags
    from `pigeon-tf` and earlier, the line is the entry's `###` heading.
  - The long text stays in git history and in the Releases, and each file's
    header says so.
  - A one-off script, run locally, does the rewrite. It isn't committed,
    because nothing runs it twice.
- **`lib/CHANGELOG.md` stays as it is.** It is the library's frozen rollup,
  already one line per PR (LIB-0047 §1), and gets a header note that it
  stopped at the hoist.

### 8. The cutover, in order

Every short URL, every pinned `uses:` and every marketplace pin must keep
resolving throughout. As LIB-0047's 2026-10-30 amendment found, a change to the
fetcher and a change to the paths its callers read never share a PR.

| # | Where | Change | Label |
| --- | --- | --- | --- |
| 1 | runway | `docs(adr): LIB-0049 finish the hoist`: this record | none |
| 2 | runway | `ci(lib-0049)`: move the reusables to `lib/github-workflows/`, the path predicates and their twin, and the layout check (§1), with the tag-only release commit (§2). Unlike LIB-0047's hoist, one PR is enough: its merge runs its own `template-release.yml`, and the only predicate the move matches is the new `workflows` one, so it cuts exactly the first tag made this way | `release:minor` |
| 3 | runway | `feat(lib-0049)`: garden's `/workflows/` pages (§3), from `lib/scripts/` | `release:patch` |
| 4 | runway | `feat(lib-0049)`: the `library` plugin with `release-pr`, the marketplace move and garden's marketplace pages (§4) | plugin `release:minor`; `workflows` `release:patch` for the generator |
| 5 | runway, both shims | Pin bump: `.lib-version`, every `@workflows/` ref, and runway's new `.claude/settings.json`; in the same step, both shims' `pages.yml` (LIB-0047's 2026-10-30 amendment, item 4) | none |
| 6 | runway | `docs(lib-0049)`: `adr/` and `runbooks/` to `lib/docs/`, the `precedence` lines and `adr-issue.sh` (§5) | `workflows` `release:patch` for the script |
| 7 | runway | `docs(lib-0049)`: delete `lib/.gitignore` and merge `CLAUDE.md` (§6) | none |
| 8 | runway | `feat(lib-0049)`: release posts read the Release (§7) | `workflows` `release:patch` |
| 9 | runway | `ci(lib-0049)`: one-line unit changelogs and the skill's wording (§7) | `release:patch` on the plugin and on `workflows` |
| 10 | runway | `docs(lib-0049)`: the backfill (§7) | none: a changelog-only change releases nothing |

pigeon-cli takes the new `workflows/` pin and the marketplace URL with its next
real change. A pigeon-cli merge releases a crate, so this record doesn't make
one.

## Consequences

- **`main`'s `.github/workflows/` is only runway's.** The `workflows` track is
  a path again, and LIB-0048's audit of "own" versus "reusable" is a directory
  listing.
- **A `workflows/` tag's commit is not on `main`.** Its parent is, and the two
  trees differ only in `.github/workflows/`. `git log main` no longer contains
  the tag itself, so a tool that asks "is this tag on `main`?" gets no for every
  new `workflows/` tag.
- **runway's releases need `BOT_GITHUB_TOKEN` with `workflows` permission.**
  Without it, the tag push fails after the changelog commit lands, and the
  track is one changelog entry ahead of its tags until a re-run.
- **The `release-pr` skill is versioned.** A change to it is a plugin release,
  and runway takes it by a pin bump, like every other part of the library.
- **Everything the library holds has a garden URL:** modules, schemas, theme
  versions, workflows and plugins.
- **Changelogs lose their prose, and Releases keep it.** Reading what changed
  in a release means opening its Release or its PR, and garden's posts do that
  for you.
- **Links to `adr/` and `runbooks/` on `main` break.** Permalinks don't.

## Out of scope

- **Consuming a `uses:` from a non-GitHub URL.** GitHub accepts only a repo
  path, so garden's page is where a caller finds the version, not what it
  calls. This is a constraint, not a deferral.
- **Moving the shims' `pages.yml` into runway.** `actions/deploy-pages` deploys
  only the calling repo's site (DEV-0156). This is a constraint, not a
  deferral.
- **Renaming the `library` marketplace or any tag track.** Both are interfaces
  a consumer wrote down. This is a design boundary, not a deferral.
- **Rewriting links to `adr/` in old Releases, PRs, issues or pigeon-cli's
  records.** Published text isn't rewritten to match a later layout. This is a
  design boundary, not a deferral.

## Verification

1. **`main` holds no reusable.** No file in `.github/workflows/` on `main` has
   a `workflow_call` trigger.
2. **A new tag holds every reusable.** `git ls-tree` on the first new
   `workflows/` tag's `.github/workflows/` lists every file in
   `lib/github-workflows/`, and its parent is on `main`.
3. **Callers run from the new tag.** runway's plan and apply, both shims'
   deploys (including `site-pages.yml`'s nested call) and runway's changelog
   callers all run green at it.
4. **garden serves them.** `noisypigeon.garden/workflows/vX.Y.Z/` and
   `noisypigeon.garden/claude-plugins/library/vX.Y.Z/marketplace.json` serve.
   Adding that marketplace by URL loads `library@library` with `release-pr`.
5. **One of each.** `lib/` has no `.gitignore` and no `CLAUDE.md`, and
   `.claude/` holds no skill.
6. **The records moved.** `adr/` and `runbooks/` are gone from the root, and a
   record's PR still gets the `adr` tag in the root `CHANGELOG.md`.
7. **Changelogs are one line.** Every entry in each unit's `CHANGELOG.md` is a
   version heading and one line. garden's release posts still show each
   release's full body.

## Amendments

### 2026-10-31: as built

Where this entry and the text above disagree, this entry is what runs.

1. **Steps 2a and 2b were one PR.** The hoist split its move from its rewire
   because the move matched every predicate. This move matches only the new
   `workflows` one, and its merge runs its own `template-release.yml`. So
   noisypigeon/runway#150 moved and rewired in one PR, and cut
   `workflows/v9.4.0`, the first tag made this way. §8's table says so.
2. **The marketplace takes §4's fallback, not a URL.** A plugin release's tag
   names a commit that copies `lib/claude-plugins/marketplace.json` to
   `/.claude-plugin/marketplace.json`, exactly as §2 does for the workflows.
   A consumer keeps pinning the `github` marketplace at the plugin's tag,
   which is the mechanism pigeon-cli already uses and needs no new Claude Code
   feature. So pigeon-cli has nothing to move.
   - **garden serves a page per plugin version** at
     `noisypigeon.garden/claude-plugins/<plugin>/vX.Y.Z/`, with the
     `.claude/settings.json` that pins it. It doesn't serve a
     `marketplace.json`.
   - **Only loadable tags get a page.** A tag is listed only if its commit's
     marketplace names the plugin at a source its tree holds, so a recreated
     pre-hoist tag is left out.
3. **`workflows/v9.4.0` is not LIB-0048's.** LIB-0048's table expected its
   label pinning and deprecation check to cut `v9.3.1` and `v9.4.0`. This
   record's PRs cut those numbers first, so LIB-0048's steps take whatever
   number comes next. Versions are a sequence, not names.
