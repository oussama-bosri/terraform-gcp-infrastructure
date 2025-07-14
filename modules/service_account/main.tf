resource "google_service_account" "backend_sa" {
  account_id   = var.account_id
  display_name = var.display_name
}

resource "google_storage_bucket_iam_member" "sa_bucket_access" {
  bucket = var.bucket_name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.backend_sa.email}"
}
