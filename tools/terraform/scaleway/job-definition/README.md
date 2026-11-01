# job-definition

A Scaleway Serverless Job definition (`scaleway_job_definition`, LIB-0053).
A run starts the image, does its work and exits; the definition costs nothing
between runs.

- **Recurring:** set `schedule` (cron) and Scaleway starts each run itself.
- **Ad hoc:** leave `schedule` null and start runs on demand, e.g. with the
  `scaleway-job-run.yml` workflow.
- **Secrets:** `secret_env` and `secret_wiring` become one Secret Manager
  secret each, reaching the run as environment variables by
  `secret_reference`, never as plain `env`.
- **Image:** pinned to a tag or digest, from a registry Scaleway can pull from
  anonymously (e.g. a public ghcr.io package).

As a workload kind it is `scaleway.job.<k>`; its inputs are named for the
entry's keys.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
