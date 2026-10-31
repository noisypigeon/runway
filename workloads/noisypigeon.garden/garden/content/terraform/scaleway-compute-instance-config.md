+++
title = "scaleway/compute-instance-config"
description = "Renders a `pigeon-cli` cloud-init document for `compute-instance`'s `cloud_init` input: the keyring, Cockpit/Alloy, a post-provision systemd unit, an optional self-delete trap and an optional static ffmpeg. It creates no resources. Since v1.1.0 (LIB-0043 §4), a keyring entry's fields may also arrive through `keyring_wiring` (a bucket's name and an API key's credentials, from other modules' outputs) and `keyring_secrets` (secret string fields), each merged over the entry of the same alias. The required-field checks run on the merged entries."
template = "module.html"
in_search_index = true

[extra]
kind = "module"
provider = "scaleway"
module = "compute-instance-config"
latest_version = "1.1.1"
github_url = "https://github.com/noisypigeon/runway/tree/main/tools/terraform/scaleway/compute-instance-config"
usage_example = ""
versions = [{ version = "0.1.0", path = "terraform/scaleway/compute-instance-config/v0.1.0" }, { version = "1.0.0", path = "terraform/scaleway/compute-instance-config/v1.0.0" }, { version = "1.1.0", path = "terraform/scaleway/compute-instance-config/v1.1.0" }, { version = "1.1.1", path = "terraform/scaleway/compute-instance-config/v1.1.1" }]
+++
