include "root" {
  path = find_in_parent_folders(".config/root.hcl")
}

terraform {
  source = get_terragrunt_dir()
}

dependency "iam_application" {
  config_path = "../../iam-application/terraform-deployer"
}

inputs = {
  application_id = dependency.iam_application.outputs.id
}
