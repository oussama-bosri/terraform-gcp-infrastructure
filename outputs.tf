output "bucket_url" {
  value = module.gcs.bucket_url
}

output "service_account_email" {
  value = module.service_account.service_account_email
} 

output "artifact_registry_repo_url" {
  value = "${google_artifact_registry_repository.docker_repo.location}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.docker_repo.repository_id}"
}

output "jenkins_artifact_key_private" {
  value     = google_service_account_key.jenkins_artifact_key.private_key
  sensitive = true
  description = "Base64-encoded private key for Jenkins Artifact Registry service account"
} 