provider "google" {
  project = var.project_id
  region  = var.region
}

module "gcs" {
  source      = "./modules/gcs"
  bucket_name = var.bucket_name
  location    = var.location
}

module "service_account" {
  source       = "./modules/service_account"
  account_id   = "backend-app-sa"
  display_name = "Backend App Service Account"
  bucket_name  = module.gcs.bucket_name
}

module "compute" {
  source = "./modules/compute"
  # You can override variables here if needed
} 

resource "google_project_service" "artifact_registry" {
  project = var.project_id
  service = "artifactregistry.googleapis.com"
  disable_on_destroy = false
}

resource "google_artifact_registry_repository" "docker_repo" {
  depends_on   = [google_project_service.artifact_registry]
  location     = var.region
  repository_id = "springboot-docker"
  description   = "Docker repo for Spring Boot app"
  format        = "DOCKER"
}

resource "google_service_account" "jenkins_artifact" {
  account_id   = "jenkins-artifact"
  display_name = "Jenkins Artifact Registry Service Account"
}

resource "google_project_iam_member" "artifact_registry_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.jenkins_artifact.email}"
}

resource "google_service_account_key" "jenkins_artifact_key" {
  service_account_id = google_service_account.jenkins_artifact.name
  keepers = {
    request_id = var.project_id
  }
  private_key_type = "TYPE_GOOGLE_CREDENTIALS_FILE"
} 