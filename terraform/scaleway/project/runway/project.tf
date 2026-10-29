# The project is workloads/private/data-ops's, renamed wg-data-ops; this leaf
# only looks it up (LIB-0046 §2). Its path, and so its state key, stays.
data "scaleway_account_project" "project" {
  project_id = local.scaleway_project_id
}

output "id" {
  description = "Project ID"
  value       = data.scaleway_account_project.project.id
}

output "name" {
  description = "Project name"
  value       = data.scaleway_account_project.project.name
}
