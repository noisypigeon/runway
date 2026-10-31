# Changelog

All notable changes to this module are documented in this file.

One line per release; its full notes are its GitHub Release (LIB-0049 §7).

## [1.1.1] - 2026-10-28

- Treat a null keyring_wiring or keyring_secrets as empty ([#223](https://github.com/noisypigeon/library/pull/223))

## [1.1.0] - 2026-10-28

- Let compute-instance-config take keyring fields from wiring and secrets ([#222](https://github.com/noisypigeon/library/pull/222))

## [1.0.0] - 2026-10-19

- Write secrets into keyring.toml and stop rendering rclone.conf in compute-instance-config ([#78](https://github.com/noisypigeon/library/pull/78))

## [0.1.0] - 2026-10-10

- Split cloud-init into compute-instance-config; stop composing modules inside compute-instance ([#269](https://github.com/noisypigeon/noisypigeon/pull/269))
