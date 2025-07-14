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