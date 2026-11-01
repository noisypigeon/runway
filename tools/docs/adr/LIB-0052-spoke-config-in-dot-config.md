# LIB-0052: A spoke's config lives in .config/, and the dead root files go

- **Author**: Willow Graysen ([@noisypigeon](https://github.com/noisypigeon)).
- **Date**: 2026-10-31.
- **Status**: Proposed. Amends:
  - LIB-0050 §4: `.pigeon/` becomes `.config/pigeon/`;
  - LIB-0001 invariant 4: a leaf's state key is its path from the repo root,
    and `root.hcl` computes it instead of taking it from the include's
    directory;
  - LIB-0003, LIB-0010 and LIB-0045, for where `root.hcl`,
    `secrets-schema.json`, `spoke.hcl` and `policies.yaml` live;
  - LIB-0050's amendment, whose frozen fetch is deleted.

  Its last step depends on LIB-0051 §5.

## Context

runway's root holds three kinds of file:

- **Dead files.** `fetch-lib.sh`, `.lib-version` and the `/.lib-src/` ignore
  exist only for the Pages shims (LIB-0050's amendment), which LIB-0051
  retires.
- **Spoke config.**
  - `spoke.hcl`, `policies.yaml`, `.mise.toml` and `.sops.yaml` are written
    by hand.
  - `root.hcl` and `secrets-schema.json` are generated from the pinned
    template and committed.
  - `.pigeon/` holds the library fetch.
- **Files a tool reads only at the root:** `README.md`, `CHANGELOG.md`,
  `CLAUDE.md`, `.gitignore`, `.github/` and `.claude/`.

The second kind can move:

- **mise** reads `.config/mise.toml` as natively as `.mise.toml`.
- **sops** takes a `--config` path.
- **The scripts** can find a spoke by any marker file.
- **Terragrunt's `find_in_parent_folders`** takes a path.

`.config/` is a neutral home for all of it, and other spokes can reuse it as
is.

## Decision

### 1. The layout

| Now | Becomes |
| --- | --- |
| `.pigeon/version`, `.pigeon/tools.sh`, `.pigeon/src/` | `.config/pigeon/version`, `.config/pigeon/tools.sh`, `.config/pigeon/src/` (gitignored) |
| `spoke.hcl` | `.config/spoke.hcl` |
| `policies.yaml` | `.config/policies.yaml` |
| `root.hcl`, `secrets-schema.json` (generated, committed) | `.config/root.hcl`, `.config/secrets-schema.json` |
| `.mise.toml` | `.config/mise.toml` |
| `.sops.yaml` | `.config/sops.yaml` |
| `fetch-lib.sh`, `.lib-version`, the `/.lib-src/` ignore | deleted, once LIB-0051 retires the shims |

Afterwards the root holds only the files a tool insists on, plus the trees:
`README.md`, `CHANGELOG.md`, `CLAUDE.md`, `.gitignore`, `.github/`, `.claude/`,
`terraform/`, `workloads/`, `zones/` and `tools/`.

### 2. `root.hcl` moves, and no state key changes

- **Every leaf includes `find_in_parent_folders(".config/root.hcl")`.** That
  covers the hand-written leaves and the stubs `resolve-workloads.sh` writes.
- **The template computes the key.** `path_relative_to_include()` is now
  relative to `.config/`, so it starts with `../`. The template strips that
  prefix: `trimprefix(path_relative_to_include(), "../")`. That gives exactly
  the path from the repo root that every key has been until now (LIB-0001
  invariant 4).
- **Repo paths come from the repo root.** `terraform/secrets/`, `workloads/`
  and `zones/` are read from `${get_parent_terragrunt_dir()}/..`.
  `spoke.hcl` is read from `${get_parent_terragrunt_dir()}/spoke.hcl`, which
  is now `.config/spoke.hcl`.
- **It is a `github/terragrunt` major.** The PR that moves runway must plan
  `No changes.` for every leaf. That plan is what proves no key moved.

### 3. The scripts find a spoke by `.config/spoke.hcl`

- **The scripts:**
  - `resolve-root-hcl.sh` writes `.config/root.hcl` and
    `.config/secrets-schema.json`;
  - `check-secrets.sh` reads the schema from there;
  - `check-policies.sh` reads `.config/policies.yaml`;
  - `resolve-workloads.sh` emits the new include.
- **The workflows** name `.config/`: `terragrunt-run`'s discovery,
  `terragrunt-detect` and the root-changelog `precedence`. Every default that
  named `.pigeon/` moves to `.config/pigeon/`.
- **For one version, every script also accepts the old root paths.** A spoke
  can take the release before it moves its files. The next major drops that
  fallback.
- **It is a `github/workflows` major.**

### 4. sops and mise

- **sops.** The mise secrets tasks pass `--config .config/sops.yaml`.
  Decryption in `root.hcl` reads each file's own metadata, and needs no
  config. Before the move, the rules' `path_regex` is checked against how sops
  matches a path when the config is passed explicitly.
- **mise.** `.config/mise.toml` keeps the same tools, env and tasks. Before
  the move, each task's working directory is checked to be the repo root.

### 5. Cutover, in order

| # | Where | Change | Label |
| --- | --- | --- | --- |
| 1 | runway | This record | none |
| 2 | runway | Scripts, workflows and the template learn `.config/` (§§2–4), with the one-version fallback | `release:major`, on `github/workflows` and `github/terragrunt` |
| 3 | runway | runway moves into `.config/` (§1). It repoints every leaf's include, regenerates `root.hcl`, and bumps its pins. It must plan `No changes.` for every leaf, and the owner applies it | none |
| 4 | runway | After LIB-0051 §5: delete `fetch-lib.sh`, `.lib-version` and the `/.lib-src/` ignore | none |
| 5 | pigeon-cli | Adopts `.config/pigeon/` directly, with its next real change. It never took `.pigeon/` | n/a |

## Consequences

- **The root is only what tools require.** A spoke's config is one directory,
  and another spoke can copy its shape.
- **A leaf's state key no longer follows from where `root.hcl` sits.** The
  template computes it, so a later move of `root.hcl` again only changes that
  one expression.
- **Running sops by hand needs `--config .config/sops.yaml`.** The mise
  tasks pass it.
- **`.pigeon/` lived for one day.** LIB-0050 is amended rather than reversed,
  because only the directory changes.

## Out of scope

- **Moving `README.md`, `CHANGELOG.md`, `CLAUDE.md`, `.gitignore`, `.github/`
  or `.claude/`.** Their tools read them only at the root. This is a
  constraint, not a deferral.
- **Changing any state key.** This is a design boundary, not a deferral.

## Verification

1. **The root is clean.** It holds only §1's list.
2. **No key moved.** Every leaf plans `No changes.` after step 3.
3. **The tasks work.** `mise run terraform-prepare` and
   `mise run secrets-edit` run from the repo root.
4. **The committed copies match.** `resolve-root-hcl.sh --check` passes
   against `.config/`.

## Amendments

### 2026-11-01: §§2-4, as built for step 2

Where this entry and the text above disagree, this entry is what runs.

1. **Checked before building**, with terragrunt 1.1.6, mise 2026.10.6 and
   sops 3.13.3:
   - **terragrunt.** `find_in_parent_folders(".config/root.hcl")` finds the
     file from any depth. `path_relative_to_include()` is then `../<leaf>`,
     so trimming `../` gives the same key.
   - **mise.** A task in `.config/mise.toml` runs at the repo root, from any
     directory.
   - **sops.** With `--config .config/sops.yaml`, sops matches `path_regex`
     against a longer path than the repo-relative one, so `^terraform/...`
     matches nothing. The moved file's rules are anchored `(^|/)` instead.
     That still refuses every other path.
2. **`root.hcl` tells the two layouts apart by its own directory.** It reads
   `spoke.hcl` and `secrets-schema.json` beside itself. Its repo paths come
   from the repo root: this file's parent when it sits in `.config/`, its
   own directory otherwise. Every key is `trimprefix(path_relative_to_include(),
   "../")`. The library clone is `.config/pigeon/src` when
   `.config/pigeon/version` exists, `.pigeon/src` otherwise.
3. **The scripts.** Each script finds its config in `.config/` when that
   holds `spoke.hcl`, at the root otherwise:
   - `resolve-root-hcl.sh` writes `root.hcl` and `secrets-schema.json`
     there;
   - `check-secrets.sh` and `check-policies.sh` read from there;
   - `resolve-workloads.sh` stubs include `.config/root.hcl` or `root.hcl` to
     match;
   - `split-secrets.sh` and `state-backup.yml` accept either layout.
4. **The workflows.** Every default that named `.pigeon/` names
   `.config/pigeon/`. Each falls back to the `.pigeon/` path when the new one
   doesn't exist, which is the one-version fallback:
   - `terragrunt-run` resolves `scripts_dir` in a step of its own;
   - the base worktree for destroys gets the clone at both paths;
   - `terragrunt-detect`'s default pattern adds `.config/`'s files;
   - the provider cache keys on `.config/root.hcl` too.
5. **`terragrunt-run` plans every unit when `.config/`'s `root.hcl`,
   `spoke.hcl` or `secrets-schema.json` changes,** as it already did for the
   root's copies. Without that, runway's move planned only its hand-written
   leaves, which proved nothing about the units' keys.
