output "bucket_url" {
  value = "gs://${google_storage_bucket.backend_bucket.name}"
}

output "bucket_name" {
  value = google_storage_bucket.backend_bucket.name
}
