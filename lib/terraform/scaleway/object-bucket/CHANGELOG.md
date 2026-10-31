# Changelog

All notable changes to this module are documented in this file.

One line per release; its full notes are its GitHub Release (LIB-0049 §7).

## [4.2.0] - 2026-10-10

- Add optional expiration_days lifecycle rule to object-bucket ([#262](https://github.com/noisypigeon/noisypigeon/pull/262))

## [4.1.1] - 2026-10-05

- Fix object-bucket ACL/website-config resources to honor project_id ([#196](https://github.com/noisypigeon/noisypigeon/pull/196))

## [4.1.0] - 2026-10-05

- Add exact_name, website hosting, and public-read ACL to object-bucket ([#194](https://github.com/noisypigeon/noisypigeon/pull/194))

## [4.0.0] - 2026-10-04

- Rename object-bucket's namespace/name to name_prefix/name_suffix, default storage_class to glacier ([#161](https://github.com/noisypigeon/noisypigeon/pull/161))

## [3.0.0] - 2026-10-03

- Continue this module's version lineage under the templates/terraform prefix ([#144](https://github.com/noisypigeon/noisypigeon/pull/144))

## [2.0.0] - 2026-10-04

- Fix object-bucket endpoint output to use the regional host, not the bucket vhost ([#135](https://github.com/noisypigeon/noisypigeon/pull/135))

## [1.0.0] - 2026-10-02

- Move scaleway modules to top-level modules/, major release each ([#120](https://github.com/noisypigeon/noisypigeon/pull/120))

## [0.2.0] - 2026-09-30

- Add force_destroy input to object-bucket ([#101](https://github.com/noisypigeon/noisypigeon/pull/101))

## [0.1.1] - 2026-09-27

- fix(adr-0072): raise GLACIER transition to Scaleway's 90-day minimum ([#77](https://github.com/noisypigeon/noisypigeon/pull/77))

## [0.1.0] - 2026-09-26

- Consolidate as terraform/modules/scaleway/object-bucket 0.1.0
