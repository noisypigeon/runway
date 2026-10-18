# willowgraysen.com

Terraform for `willowgraysen.com`, the namespace for
[`pigeon-cli`](https://github.com/noisypigeon/pigeon-cli) and data-ops infrastructure: object
storage, the job cluster, observability, and the IAM that ties them together. **There is no
website** — the domain redirects to [noisypigeon.com](https://noisypigeon.com), and that
redirect is managed in [`noisypigeon/blog`](https://github.com/noisypigeon/blog).

This repo is a spoke of [`noisypigeon/library`](https://github.com/noisypigeon/library),
which holds the Terraform modules, the shared Terragrunt root template and the CI this repo calls
([LIB-0001](https://github.com/noisypigeon/library/blob/main/docs/adr/LIB-0001-composable-hub-and-spoke-repo-architecture.md)).

## Working on it

```sh
mise install          # terraform, terragrunt, sops
```

Terraform changes are planned on the PR and applied by commenting `terragrunt apply`. Conventions
and the sensitivity rules are in [CLAUDE.md](CLAUDE.md). Decisions about this
repo are recorded in [`noisypigeon/library`](https://github.com/noisypigeon/library/blob/main/docs/adr/), not here
([LIB-0017](https://github.com/noisypigeon/library/blob/main/docs/adr/LIB-0017-spokes-do-not-get-their-own-adrs.md)).

## Contributing

This repo manages private infrastructure and doesn't take outside contributions; interactions are
limited to prior contributors. If you've found a security problem, please don't open a public
issue — contact [@noisypigeon](https://github.com/noisypigeon) directly.
