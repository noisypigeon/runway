+++
title = "scaleway/compute-instance"
description = "A Scaleway compute Instance (`scaleway_instance_server`) with a randomized name suffix. It takes an already-rendered `cloud_init` document, normally `compute-instance-config`'s, and block volumes the caller creates. Since v8.0.0 (LIB-0043) it also creates the instance's own routed public IPv4 (`public_ipv4`) and attaches it to a Private Network (`enable_private_network`, `private_network_id`), with a standalone NIC so that attaching or detaching never replaces the server. `project_id` is required."
template = "module.html"
in_search_index = true

[extra]
kind = "module"
provider = "scaleway"
module = "compute-instance"
latest_version = "8.0.0"
github_url = "https://github.com/noisypigeon/library/tree/main/terraform/scaleway/compute-instance"
usage_example = """
module "instance" {
  source      = "https://noisypigeon.garden/terraform/scaleway/compute-instance/v8.0.0"
  name_prefix = "pigeon-cli"
  name_suffix = "worker"
  project_id  = local.project_id

  type                  = "COMPUTE3-X8C-16G"
  cloud_init            = module.config.cloud_init
  additional_volume_ids = [module.volume.id]

  public_ipv4            = false
  enable_private_network = true
  private_network_id     = module.private_network.id
}
"""
versions = [{ version = "3.0.0", path = "terraform/scaleway/compute-instance/v3.0.0" }, { version = "4.0.0", path = "terraform/scaleway/compute-instance/v4.0.0" }, { version = "5.0.0", path = "terraform/scaleway/compute-instance/v5.0.0" }, { version = "5.0.1", path = "terraform/scaleway/compute-instance/v5.0.1" }, { version = "5.1.0", path = "terraform/scaleway/compute-instance/v5.1.0" }, { version = "5.2.0", path = "terraform/scaleway/compute-instance/v5.2.0" }, { version = "5.3.0", path = "terraform/scaleway/compute-instance/v5.3.0" }, { version = "5.3.1", path = "terraform/scaleway/compute-instance/v5.3.1" }, { version = "5.4.0", path = "terraform/scaleway/compute-instance/v5.4.0" }, { version = "5.5.0", path = "terraform/scaleway/compute-instance/v5.5.0" }, { version = "5.6.0", path = "terraform/scaleway/compute-instance/v5.6.0" }, { version = "5.6.1", path = "terraform/scaleway/compute-instance/v5.6.1" }, { version = "5.7.0", path = "terraform/scaleway/compute-instance/v5.7.0" }, { version = "6.0.0", path = "terraform/scaleway/compute-instance/v6.0.0" }, { version = "6.1.0", path = "terraform/scaleway/compute-instance/v6.1.0" }, { version = "7.0.0", path = "terraform/scaleway/compute-instance/v7.0.0" }, { version = "8.0.0", path = "terraform/scaleway/compute-instance/v8.0.0" }]
+++
