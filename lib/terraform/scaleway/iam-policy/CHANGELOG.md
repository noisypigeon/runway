# Changelog

All notable changes to this module are documented in this file.

One line per release; its full notes are its GitHub Release (LIB-0049 §7).

## [4.0.0] - 2026-10-04

- Split iam-policy's application/API-key into iam-application and iam-api-key modules ([#162](https://github.com/noisypigeon/noisypigeon/pull/162))

## [3.0.0] - 2026-10-03

- Continue this module's version lineage under the templates/terraform prefix ([#144](https://github.com/noisypigeon/noisypigeon/pull/144))

## [2.0.1] - 2026-10-04

- Shorten iam-policy generated application name suffix ([#134](https://github.com/noisypigeon/noisypigeon/pull/134))

## [2.0.0] - 2026-10-02

- Move scaleway modules to top-level modules/, major release each ([#120](https://github.com/noisypigeon/noisypigeon/pull/120))

## [1.1.1] - 2026-09-27

- fix(adr-0070): downgrade admin bucket-policy statement to a supported version ([#73](https://github.com/noisypigeon/noisypigeon/pull/73))

## [1.1.0] - 2026-09-27

- feat(adr-0069): guard scaleway/iam-policy against bucket-policy self-lockout ([#71](https://github.com/noisypigeon/pigeon/pull/71))

## [1.0.0] - 2026-09-27

- feat(adr-0066): guard scaleway/iam-policy against bucket-scope widening ([#64](https://github.com/noisypigeon/pigeon/pull/64))

## [0.1.0] - 2026-09-26

- Consolidate as terraform/modules/scaleway/iam-policy 0.1.0
