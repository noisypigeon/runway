# Changelog

One line per PR across this whole repo, sectioned by date, newest first. Every
merged PR gets exactly one line here. DEV-0160 is the contract, adopted here by
RUN-0000.

Entry format is `- [<tag>] <PR title> ([#N](pr-url))`, where `<tag>` is one of:

- `terraform` — `terraform/`, `root.hcl`, `spoke.hcl`, `.sops.yaml`
- `adr` — decision records under `adr/`
- `ci` — `.github/` workflows
- `repo` — anything else (root docs, `.mise.toml`, `fetch-lib.sh`)

All of them are written by `root-changelog.yml`, which runs on every merged PR
with no exceptions. It calls `root-changelog.sh` out of the pinned library
rather than a vendored copy, and that script inserts below the marker at the end
of this header — keep that line where it is.

This file starts at this repo's own beginning. The Terraform leaves imported by
RUN-0001 keep their earlier history in git; changelog entries from before then
stayed in `noisypigeon/noisypigeon`.

<!-- entries below; newest first -->

## 2026-10-15

- [terraform] refactor(terraform): rename the single-module leaves to LIB-0004's layout ([#7](https://github.com/noisypigeon/willowgraysen.com/pull/7))
- [terraform] refactor(terraform): grafana leaf onto the template's latent provider and a pinned dashboard ([#6](https://github.com/noisypigeon/willowgraysen.com/pull/6))
- [terraform] refactor(terraform): move the redirect leaf onto the cloudflare wrapper modules ([#5](https://github.com/noisypigeon/willowgraysen.com/pull/5))
- [terraform] fix(terraform): stop the overview dashboard planning a change every run ([#4](https://github.com/noisypigeon/willowgraysen.com/pull/4))
- [terraform] fix(terraform): point the state bucket output at terraform/secrets.enc ([#3](https://github.com/noisypigeon/willowgraysen.com/pull/3))
- [terraform] feat(run-0001)!: run willowgraysen.com's Terraform from this repo ([#2](https://github.com/noisypigeon/willowgraysen.com/pull/2))
- [adr] chore(run-0000): bootstrap the repo as a pigeon-lib spoke and open the RUN- domain ([#1](https://github.com/noisypigeon/willowgraysen.com/pull/1))
