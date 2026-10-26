# Signs in with this spoke's Scaleway key, which it doesn't manage. If it ever does, it needs a breakglass key.
module "iam_application" {
  source = "https://noisypigeon.garden/terraform/scaleway/iam-application/v0.1.0"
  name   = "willowgraysen-com-terraform-deploy"
}

output "id" {
  description = "IAM application ID -- read by the terraform-deployer policy and API key leaves through Terragrunt dependency blocks"
  value       = module.iam_application.id
}
