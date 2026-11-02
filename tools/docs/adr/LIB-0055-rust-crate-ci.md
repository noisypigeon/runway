# LIB-0055: A reusable workflow runs a Rust crate's CI on its pull requests

- **Author**: Willow Graysen ([@noisypigeon](https://github.com/noisypigeon)).
- **Date**: 2026-11-01.
- **Status**: Proposed. Consumed first by pigeon-cli's CLI-0165.

## Context

pigeon-cli is the family's only crate. Its release pipeline already lives
here as `rust-crate-release.yml` (its CLI-0161). That workflow runs
`fmt-check` and `lint` after a merge to `main`, then publishes. **No
workflow runs the crate's tests, on any trigger**
(noisypigeon/pigeon-cli#47). A test-breaking commit is merged, released
and on crates.io before anyone notices.

pigeon-cli's CLI-0165 adds a check on every pull request. LIB-0001 puts
reusable CI in the hub, and pigeon-cli's caller workflows are thin by
CLI-0161. So the mechanics live here, as they did for the release
(CLI-0161) and the container image (LIB-0019).

The suite needs external binaries that differ by crate. pigeon-cli's
tests need the pinned `rclone` and `ffmpeg` its `Dockerfile` ships (its
CLI-0155, CLI-0163). Ubuntu's packages are too old and fail 6 tests.
Only the spoke knows which binaries it needs and at what versions,
which is LIB-0019 §2's split.

## Decision

### 1. `tools/github/workflows/rust-crate-ci.yml`, a reusable workflow

A `workflow_call` workflow with one job on `ubuntu-24.04` (overridable):

1. `actions/checkout@v4`;
2. `jdx/mise-action@v2`, so the caller's mise config chooses the toolchain,
   as in `rust-crate-release.yml`;
3. `rustup component add rustfmt clippy`;
4. `Swatinem/rust-cache@v2`;
5. the caller's `setup` snippet, if any;
6. `mise run <task>`, by default `ci`.

The caller keeps what can't live here, as it does for the release: the
trigger (`pull_request`, `workflow_dispatch`), `permissions`, and
`concurrency`.

### 2. Inputs

| Input | Default | |
|---|---|---|
| `task` | `ci` | the mise task that is the gate |
| `runner` | `ubuntu-24.04` | |
| `setup` | `""` | shell (`bash -e`) run before the task, e.g. to put pinned binaries on `$GITHUB_PATH`. Empty skips it |

`setup` is a snippet, not a script path, for the reason LIB-0019 §2 gives
for `smoke_test`: it is the spoke's own knowledge, and LIB-0002 keeps
scripts out of spokes.

### 3. No library fetch

The job runs only the caller's own mise task. It reads nothing from
`tools/github/scripts/`, so it has no `fetch_script`/`scripts_dir`
inputs. If a later task needs the scripts, those inputs can be added
then, with `rust-crate-release.yml`'s defaults.

### 4. Release

`release:minor`. This is a new, backwards-compatible workflow, so the
next tag is `github/workflows/v11.3.0`. `tools/README.md`'s "What the CI
track holds" names it next to the crate release pipeline.

## Consequences

- A crate gets its full gate on every PR with a ~15-line caller.
- The gate is the caller's own `mise run ci`, so CI and the local gate
  cannot drift.
- One more workflow to keep on the track's Node.js and action versions
  (runway#146).

## Out of scope

- **Making the check required.** That is a branch-protection setting in
  each spoke, set by its owner.
- **macOS legs.** Nothing in the family needs them for tests yet.
- **Running tests inside `rust-crate-release.yml`** before publishing.
  The PR check covers the normal path. A push straight to `main` is
  still unguarded, and that is a separate decision.

## Verification

- `scripts-test`'s layout job passes: the file sits in
  `tools/github/workflows/` and declares `workflow_call`.
- After the release, pigeon-cli's CLI-0165 PR runs it green on a real
  runner. That is this workflow's first real call.
