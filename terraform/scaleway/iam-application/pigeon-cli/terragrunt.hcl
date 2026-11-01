include "root" {
  path = find_in_parent_folders(".config/root.hcl")
}

terraform {
  source = get_terragrunt_dir()
}
