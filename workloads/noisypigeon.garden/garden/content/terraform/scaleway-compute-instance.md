+++
title = "scaleway/compute-instance"
description = "A Scaleway compute Instance (`scaleway_instance_server`) with a randomized name suffix, provisioned unconditionally for `pigeon-cli` (ADR-0118): rclone/neovim, a `keyring.toml` + `rclone.conf` rendered from one `keyring` list, and optional Cockpit/Alloy wiring — all grouped under `user_config`/`instance_config`."
template = "module.html"
in_search_index = true

[extra]
kind = "module"
provider = "scaleway"
module = "compute-instance"
latest_version = "8.0.0"
github_url = "https://github.com/noisypigeon/library/tree/main/terraform/scaleway/compute-instance"
usage_example = """
module "compute" {
  source                = "https://noisypigeon.garden/terraform/scaleway/compute-instance/v4.0.0"
  name_prefix           = "job-example"
  name_suffix           = "worker"
  additional_volume_ids = [module.volume.id]

  user_config = {
    ssh_key = local.ssh_key_public_key
  }

  instance_config = {
    type    = "COMPUTE3-X8C-16G"
    cockpit = local.cockpit
    # image omitted -- defaults to "ubuntu_jammy"
  }

  keyring = [
    {
      kind          = "bucket"
      alias         = "source"
      endpoint      = module.bucket.endpoint
      bucket        = module.bucket.name
      access_key_id = module.iam.access_key
      secret_key    = module.iam.secret_key
      provider      = local.scaleway_s3_provider_name
    }
  ]
}
"""
versions = [{ version = "3.0.0", path = "terraform/scaleway/compute-instance/v3.0.0" }, { version = "4.0.0", path = "terraform/scaleway/compute-instance/v4.0.0" }, { version = "5.0.0", path = "terraform/scaleway/compute-instance/v5.0.0" }, { version = "5.0.1", path = "terraform/scaleway/compute-instance/v5.0.1" }, { version = "5.1.0", path = "terraform/scaleway/compute-instance/v5.1.0" }, { version = "5.2.0", path = "terraform/scaleway/compute-instance/v5.2.0" }, { version = "5.3.0", path = "terraform/scaleway/compute-instance/v5.3.0" }, { version = "5.3.1", path = "terraform/scaleway/compute-instance/v5.3.1" }, { version = "5.4.0", path = "terraform/scaleway/compute-instance/v5.4.0" }, { version = "5.5.0", path = "terraform/scaleway/compute-instance/v5.5.0" }, { version = "5.6.0", path = "terraform/scaleway/compute-instance/v5.6.0" }, { version = "5.6.1", path = "terraform/scaleway/compute-instance/v5.6.1" }, { version = "5.7.0", path = "terraform/scaleway/compute-instance/v5.7.0" }, { version = "6.0.0", path = "terraform/scaleway/compute-instance/v6.0.0" }, { version = "6.1.0", path = "terraform/scaleway/compute-instance/v6.1.0" }, { version = "7.0.0", path = "terraform/scaleway/compute-instance/v7.0.0" }, { version = "8.0.0", path = "terraform/scaleway/compute-instance/v8.0.0" }]
+++
