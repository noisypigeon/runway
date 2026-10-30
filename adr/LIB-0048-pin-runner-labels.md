# LIB-0048: Pin runner labels past macos-14

- **Author**: Willow Graysen ([@noisypigeon](https://github.com/noisypigeon)).
- **Date**: 2026-10-30.
- **Status**: Proposed. Applies LIB-0001 invariant 2 to runner labels.
  Amends CLI-0161's release matrix, through the caller it already owns.

## Context

pigeon-cli's release of 0.4.60 was its first run through runway's
`rust-crate-release.yml@workflows/v9.3.0` (LIB-0047). It was triggered by the
merge of noisypigeon/pigeon-cli#146, and it ran at about 19:10 UTC on
2026-10-30. Both `build-binaries` jobs on `macos-14` failed in one second,
before any step ran:

> This job failed because of a scheduled macOS 14 runner image brownout.
> macOS 14 runner images will be retired on November 2, 2026.

[actions/runner-images#13518](https://github.com/actions/runner-images/issues/13518)
is GitHub's notice. It says:

- **Deprecation** of `macos-14`, `macos-14-large` and `macos-14-xlarge` began
  on 2026-07-06.
- **Retirement** is on **2026-11-02**.
- **Brownouts**, in which every job fails, run from 14:00 to 00:00 UTC on
  Oct 5, 12, 16, 19, 23, 26, 29, 30 and 31, and on Nov 1.
- **The suggested replacements** are `macos-latest`, `macos-15` or
  `macos-26`.

The run fell inside the Oct 30 window. pigeon-cli's releases on Oct 20 fell
between windows, which is why this is the first failure. For four months the
deprecation was announced only in annotations on green runs, and nobody
read them.

**The "Ubuntu error" is not one.** The Linux jobs (`ubuntu-24.04` and
`ubuntu-24.04-arm`) succeeded. What the run showed for Ubuntu is a notice on
the `release` job, which runs on `ubuntu-latest`: `ubuntu-latest` is moving
from Ubuntu 24.04 to 26.04 over Oct 19 to Nov 19
([runner-images#14748](https://github.com/actions/runner-images/issues/14748)).
That is a silent change of image under a label nobody edits. Nothing in the
family uses `ubuntu-22.04`, the other image now being deprecated
([#14254](https://github.com/actions/runner-images/issues/14254)).

**What 0.4.60 got.** The `release` job finished before the matrix started:

| Artifact | State |
|---|---|
| crates.io `pigeon-cli` 0.4.60 | published |
| `chore(release): v0.4.60` commit on `main`, `v0.4.60` tag | landed |
| GitHub Release `v0.4.60` | created, marked Latest |
| Linux tarballs (x86_64, aarch64) | attached |
| macOS tarballs (aarch64, x86_64) | **missing** |
| GHCR image `0.4.60` | **missing**: the `image` job needs `release`, which failed, so it was skipped. GHCR's newest is still 0.4.59 |

This is not the hole CLI-0161's amendment item 9 records. `v0.4.54` there is a
tag with no crate, Release or binaries, because `cargo publish` failed after
the push. 0.4.60 is released; only two of its artifacts are missing.

**Where runner labels live today.**

- **pigeon-cli's `release.yml`** passes the `targets` matrix. It is the
  family's only use of macOS:
  - `macos-14` → `aarch64-apple-darwin`, smoke-tested;
  - `macos-14` → `x86_64-apple-darwin`, `smoke_test: false`;
  - `ubuntu-24.04-arm` → `aarch64-unknown-linux-gnu`;
  - `ubuntu-24.04` → `x86_64-unknown-linux-gnu`.
- **runway's reusable workflows** all run on `ubuntu-latest`. That covers
  `rust-crate-release.yml`'s `release` job, `container-image-release.yml`'s
  merge job, `terragrunt-ack`, `terragrunt-detect`, `terragrunt-run`,
  `site-dispatch`, `site-generate`, `site-pages`, both `zola-site-pages` jobs,
  `spoke-root-changelog`, `state-backup`, `interaction-limits-renew` and
  `blog-changelog`. Only `container-image-release.yml`'s default `platforms`
  pins its labels, to `ubuntu-24.04` and `ubuntu-24.04-arm`.
- **runway's own jobs** (`module-docs`, `root-changelog`, `scripts-test` and
  `template-release`) are on `ubuntu-latest`. Its other workflows only call
  the reusable ones.
- **The Pages shims' `pages.yml`** carry no `runs-on`. Each is one `uses:` of
  `site-pages.yml`.

**The x86_64 macOS target is already cross-compiled.** `macos-14` is an arm64
image; the x64 one is `macos-14-large`. So `crate-build-release.sh` already
built `x86_64-apple-darwin` on arm64, by `rustup target add` and
`cargo build --target`. That is why its smoke test is off. Every arm64 macOS
image can do the same. x64 hosts still exist, as `macos-15-intel` and
`macos-26-intel`, and `macos-latest` is now macOS 26 on arm64.

## Decision

1. **The Apple targets build on `macos-15`.** Both pigeon-cli matrix entries
   move from `macos-14` to `macos-15`, the arm64 macOS 15 image, and nothing
   else in them changes. aarch64 builds natively and is smoke-tested. x86_64 is
   cross-compiled and not smoke-tested, exactly as on `macos-14`. The binaries'
   minimum macOS is set by Rust's deployment target, not by the build image, so
   users see no difference. The labels not chosen:
   - `macos-latest` floats, which §2 rules out.
   - `macos-26` is where GitHub is moving the default OpenSSL from 3 to 4
     ([#14856](https://github.com/actions/runner-images/issues/14856)), and
     pigeon-cli's lockfile carries `openssl-sys`. That change should not ride
     along with a forced runner move. `macos-26` is the next step, through
     §4, when `macos-15` is deprecated.
   - The `-intel` images would bring back a native x86_64 smoke test, but they
     are the images GitHub will drop next, along with Apple's Intel support. One
     arm64 image for both triples leaves one label to move next time.

2. **A target's runner stays in the caller's matrix; every other label the
   family writes is a pinned version.**
   - **`targets` stays a required input** of `rust-crate-release.yml`, with
     no default. Which runner builds which triple is crate-specific, and
     CLI-0161 made every crate-specific value an input. A default here would
     be a second place to forget.
   - **No family workflow uses a `-latest` label.** Every `runs-on: ubuntu-latest`
     in runway's reusable workflows and in runway's own jobs becomes
     `ubuntu-24.04`, the image those jobs have run on until now. LIB-0001
     invariant 2 says a spoke consumes versions, never branches, and a
     `-latest` label is a branch of images. The move of `ubuntu-latest` to 26.04
     now under way changes every job in the family without a PR, a release or
     a changelog line. Pinned, the move to `ubuntu-26.04` is a deliberate
     `workflows/` release, like any other change to what the workflows do.
   - **The reusable workflows don't parametrize their own runners.** No
     caller needs another image, and an input nobody sets only hides the
     label from the next audit.

3. **0.4.60 is recovered by re-running its failed jobs, and only before
   retirement.**
   - **Primary.** Run "Re-run failed jobs" on pigeon-cli run 41112699084
     outside a brownout. The windows that remain are **Oct 31 00:00–14:00 UTC**
     and **Nov 1 00:00–14:00 UTC**.
     - **What it re-runs.** The two macOS `build-binaries` jobs, which attach
       their tarballs to the existing Release, and then the `image` job that
       depends on them, which pushes GHCR `0.4.60`. The succeeded `release`
       job is not re-run, so nothing is cut, tagged or republished.
       `crate-release.sh` is idempotent anyway (CLI-0150).
     - **Why the timing matters.** A re-run reuses the workflow definition
       from the original commit, so it still asks for `macos-14`. The matrix
       change in §1 cannot help this run.
   - **Fallback.** If the re-run misses the windows or fails, 0.4.60 stays as
     it is: crate, tag, and a Release with Linux binaries only, with no macOS
     binaries and no image. The next merge to pigeon-cli's `main`, which is §1's
     change itself, releases a complete 0.4.61. No workflow is built to
     backfill an existing tag's artifacts, for one release.
   - **Recorded in pigeon-cli.** Either way, pigeon-cli records the outcome
     as a CLI-0161 amendment beside item 9, since that is where its version
     sequence is accounted for.

4. **Deprecations are caught by a weekly check, not by a brownout.** A
   scheduled workflow in runway runs a new `lib/scripts/check-runner-labels.sh`
   once a week:
   - **What it reads.** It reads the open `Announcement` issues in
     actions/runner-images and pulls out every label they deprecate. These
     issues use a fixed "Workflows using the `<label>` image label" wording.
   - **What it checks.** Every `runs-on:` and matrix `runner` value in runway,
     pigeon-cli and the two Pages shims.
   - **What it reports.** For each label in use that is announced for
     removal, it opens one issue in runway, or updates the one already open,
     naming the label, the files that use it, the retirement date and the
     announcement.
   - **Lead time.** GitHub announces months ahead: macOS 14's announcement came
     ten months before retirement, and its brownouts four weeks before. So a
     weekly check gives the whole announcement period to move.
   - **Known next match.** `macos-15` will be its first match, when macOS 27
     images reach GA and GitHub keeps only the latest two.

## Consequences

- **Minimal fix.** The fix that stops the bleeding is one line per target in
  pigeon-cli and needs no `workflows/` release, because the matrix is the
  caller's.
- **Images change only by PR.** Every image change in the family becomes a
  PR with a release behind it, and a job's image no longer changes under it.
  The cost is that pinned labels age, and GitHub brownouts every label it
  retires. §4 is what keeps that from being the next 0.4.60.
- **0.4.60's macOS artifacts depend on the user.** They exist only if the
  re-run happens in a window before Nov 2. Otherwise 0.4.60 is the one
  pigeon-cli release with Linux binaries only, and no image.

**Implementation, in order.** pigeon-cli releases on every merge to `main`, so
each pigeon-cli merge publishes to crates.io and can't be undone.

| # | Where | Change | Label | Pins |
|---|---|---|---|---|
| 0 | pigeon-cli run 41112699084 | Re-run failed jobs, Oct 31 or Nov 1, 00:00–14:00 UTC (§3) | n/a | none |
| 1 | runway | `docs(adr): LIB-0048 pin runner labels past macos-14`: this record | none (docs only) | none |
| 2 | pigeon-cli | `ci(lib-0048): build macOS targets on macos-15`: both matrix entries (§1), plus the CLI-0161 amendment recording 0.4.60's outcome. Merge before Nov 2; it releases 0.4.61 | none (releases on merge) | none: the matrix is the caller's |
| 3 | runway | `ci(lib-0048): pin runs-on to ubuntu-24.04`: every reusable and own job (§2) | `release:patch` → `workflows/v9.3.1` | none on its own; see 5 |
| 4 | runway | `ci(lib-0048): weekly runner-deprecation check`: the workflow, `check-runner-labels.sh` and a `scripts-test` case (§4) | `release:minor` → `workflows/v9.4.0` | none on its own |
| 5 | runway, both shims, pigeon-cli | Bump `@workflows/v9.3.0` to `@workflows/v9.4.0`: runway's own callers (`blog-changelog-on-merge`, `garden-generate`, `interaction-limits-monthly`, `root-changelog`, `sites`, `terragrunt-apply` and `terragrunt-plan`); `pages.yml` in `noisypigeon/noisypigeon.com` and `noisypigeon/noisypigeon.garden`; pigeon-cli's two `uses:` with its `.lib-version`, which must stay equal | runway: `release:patch` (any `.github/workflows/*.yml` change releases `workflows/`; the callers stay on `v9.4.0`); shims: none; pigeon-cli: rides with its next real change | as listed |

Steps 3 and 4 have no deadline. `ubuntu-24.04` is supported well beyond the
`ubuntu-latest` move, and pinning only stops jobs from moving to 26.04 under
us.

## Out of scope

- **Node 20 action deprecation.** The same run warns that `actions/checkout@v4`
  and `jdx/mise-action@v2` target Node.js 20 and are being forced onto
  Node.js 24. Bumping them across the family is a separate change, deferred to
  [noisypigeon/runway#146](https://github.com/noisypigeon/runway/issues/146).
- **A backfill workflow for an existing tag's binaries or image.** It is a
  permanent boundary, not deferred. §3's re-run covers the one case that
  needed one, and a release whose artifacts are lost is otherwise superseded
  by the next merge.
- **Moving to `ubuntu-26.04` or `macos-26`.** Each will be its own change, when
  §4 reports the label it replaces or a job needs the newer image.

## Verification

- **Step 0.** Release `v0.4.60` lists four tarballs, including
  `aarch64-apple-darwin` and `x86_64-apple-darwin`, and GHCR
  `ghcr.io/noisypigeon/pigeon-cli` has tag `0.4.60`. Or, if the re-run did not
  happen, pigeon-cli's CLI-0161 amendment says so.
- **Step 2.** pigeon-cli's release of 0.4.61 is green on all four
  `build-binaries` jobs and on `image`, with no brownout annotation.
- **Step 3.** `grep -rn 'ubuntu-latest\|macos-latest' .github/workflows/`
  in runway matches nothing.
- **Step 4.** The check finds no match against the current announcements,
  and a test fixture announcing `ubuntu-24.04` produces one.
