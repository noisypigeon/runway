# Changelog

All notable changes to this template are documented in this file.

One line per release; its full notes are its GitHub Release (LIB-0049 §7).

## [9.1.2] - 2026-10-29

- Point the template, theme and plugin at runway (LIB-0047) ([#103](https://github.com/noisypigeon/runway/pull/103))

## [9.1.1] - 2026-10-28

- Name the releases that brought Backblaze grants ([#236](https://github.com/noisypigeon/library/pull/236))

## [9.1.0] - 2026-10-28

- Grant guard for cross-workload Backblaze keys (LIB-0045) ([#235](https://github.com/noisypigeon/library/pull/235))

## [9.0.0] - 2026-10-28

- Scaleway compute kinds, their guards and the deployer's grants ([#226](https://github.com/noisypigeon/library/pull/226))

## [8.2.0] - 2026-10-28

- Read workload module versions from a run's tag list ([#215](https://github.com/noisypigeon/library/pull/215))

## [8.1.0] - 2026-10-28

- A workload's own Backblaze key, and providers with no spoke-wide credentials ([#208](https://github.com/noisypigeon/library/pull/208))

## [8.0.1] - 2026-10-27

- A workload in its own project doesn't repeat its name in its resources ([#206](https://github.com/noisypigeon/library/pull/206))

## [8.0.0] - 2026-10-26

- Refuse unwrapped unit files (LIB-0039) ([#203](https://github.com/noisypigeon/library/pull/203))

## [7.1.0] - 2026-10-26

- Wrapped unit files, dnsRecords and zone services (LIB-0039) ([#202](https://github.com/noisypigeon/library/pull/202))

## [7.0.0] - 2026-10-26

- Compose deployers and redirects from single-resource modules (LIB-0038) ([#195](https://github.com/noisypigeon/library/pull/195))

## [6.1.0] - 2026-10-25

- Read workloads that live in their zone (LIB-0037) ([#189](https://github.com/noisypigeon/library/pull/189))

## [6.0.0] - 2026-10-25

- Refuse zones.yaml, workload rulesets and redirects, and hand-written zone leaves ([#181](https://github.com/noisypigeon/library/pull/181))

## [5.6.0] - 2026-10-24

- Add zone units, zones/<zone>/zone.yaml (LIB-0036) ([#176](https://github.com/noisypigeon/library/pull/176))

## [5.5.0] - 2026-10-24

- A site workload's features.githubPages implies its Pages CNAMEs (LIB-0034) ([#168](https://github.com/noisypigeon/library/pull/168))

## [5.4.0] - 2026-10-23

- A workload's Cloudflare token is minted with the breakglass token (LIB-0033) ([#160](https://github.com/noisypigeon/library/pull/160))

## [5.3.0] - 2026-10-23

- Workloads sign in to Cloudflare with their own token; bootstrap keys only mint (LIB-0033) ([#159](https://github.com/noisypigeon/library/pull/159))

## [5.2.0] - 2026-10-23

- Workloads can own Cloudflare zones, records, rulesets and redirects (LIB-0030) ([#152](https://github.com/noisypigeon/library/pull/152))

## [5.1.0] - 2026-10-22

- Workloads can declare Backblaze buckets and API keys (LIB-0029) ([#145](https://github.com/noisypigeon/library/pull/145))

## [5.0.1] - 2026-10-22

- A workload's state bucket uses the standard storage class (LIB-0028) ([#143](https://github.com/noisypigeon/library/pull/143))

## [5.0.0] - 2026-10-22

- Workload state moves into each workload's own bucket (LIB-0028) ([#142](https://github.com/noisypigeon/library/pull/142))

## [4.5.0] - 2026-10-21

- Add a workload secrets.yaml in SOPS YAML (LIB-0025) ([#119](https://github.com/noisypigeon/library/pull/119))

## [4.4.0] - 2026-10-20

- Give each workload its own deployer, and stage its applies (LIB-0024) ([#114](https://github.com/noisypigeon/library/pull/114))

## [4.3.1] - 2026-10-20

- Stop telling spokes to commit workload stubs ([#106](https://github.com/noisypigeon/library/pull/106))

## [4.3.0] - 2026-10-20

- Support workload leaves in the root.hcl template (LIB-0023) ([#104](https://github.com/noisypigeon/library/pull/104))

## [4.2.0] - 2026-10-20

- feat(root-hcl): lock Terraform state on both backends (LIB-0022) ([#91](https://github.com/noisypigeon/library/pull/91))

## [4.1.1] - 2026-10-17

- Name the hub noisypigeon/library ([#70](https://github.com/noisypigeon/library/pull/70))

## [4.1.0] - 2026-10-17

- Add per-leaf breakglass credentials to root.hcl and check-secrets ([#67](https://github.com/noisypigeon/pigeon-lib/pull/67))

## [4.0.0] - 2026-10-17

- Split spoke secrets into one sops file per concern ([#62](https://github.com/noisypigeon/pigeon-lib/pull/62))

## [3.0.0] - 2026-10-16

- Fixed secret names checked against a schema (root.hcl v3, workflows v2) ([#59](https://github.com/noisypigeon/pigeon-lib/pull/59))

## [2.2.1] - 2026-10-16

- Drop pigeon.dev from comments and docs ([#55](https://github.com/noisypigeon/pigeon-lib/pull/55))

## [2.2.0] - 2026-10-16

- Zone leaves at terraform/cloudflare/<zone>/<module>/<instance>/, with their zone ID from the template (LIB-0008) ([#47](https://github.com/noisypigeon/pigeon-lib/pull/47))

## [2.1.0] - 2026-10-15

- State backend selectable in spoke.hcl: Scaleway or Cloudflare R2 (LIB-0007) ([#39](https://github.com/noisypigeon/pigeon-lib/pull/39))

## [2.0.0] - 2026-10-15

- Providers enabled and configured in spoke.hcl (LIB-0005) ([#36](https://github.com/noisypigeon/pigeon-lib/pull/36))

## [1.2.0] - 2026-10-15

- A latent Scaleway Cockpit Grafana provider in the root.hcl template ([#32](https://github.com/noisypigeon/pigeon-lib/pull/32))

## [1.1.0] - 2026-10-15

- Optional extra providers and Backblaze support in the root.hcl template ([#21](https://github.com/noisypigeon/pigeon-lib/pull/21))

## [1.0.1] - 2026-10-15

- Mark the root.hcl template as generated and committed in spokes ([#18](https://github.com/noisypigeon/pigeon-lib/pull/18))

## [1.0.0] - 2026-10-15

- Add the spokes' Terragrunt root.hcl template ([#16](https://github.com/noisypigeon/pigeon-lib/pull/16))
