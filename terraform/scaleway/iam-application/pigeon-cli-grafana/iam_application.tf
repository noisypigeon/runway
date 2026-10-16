# The IAM identity Terraform uses to manage pigeon-cli's Grafana dashboards
# (ADR-0135). Its policy and API key are sibling leaves that depend on this one.
module "iam_application" {
  source = "https://pigeon.dev/modules/scaleway/iam-application/v0.1.0"
  name   = "pigeon-cli-grafana"
}

output "id" {
  description = "IAM application ID -- read by the pigeon-cli-grafana policy, API key and dashboard leaves through Terragrunt dependency blocks"
  value       = module.iam_application.id
}
