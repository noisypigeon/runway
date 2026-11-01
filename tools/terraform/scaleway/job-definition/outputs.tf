output "id" {
  description = "Job definition ID, as region/uuid"
  value       = scaleway_job_definition.this.id
}

output "name" {
  description = "Job definition name"
  value       = scaleway_job_definition.this.name
}

output "recurring" {
  description = "Whether Scaleway starts the job's runs on its schedule"
  value       = var.schedule != null
}
