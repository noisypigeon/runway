include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = get_terragrunt_dir()
}

dependency "iam_application" {
  config_path = "../../../scaleway/iam-application/pigeon-cli-grafana"
}

dependency "iam_api_key" {
  config_path = "../../../scaleway/iam-api-key/pigeon-cli-grafana"
}

inputs = {
  application_id     = dependency.iam_application.outputs.id
  grafana_auth_token = dependency.iam_api_key.outputs.secret_key
}
