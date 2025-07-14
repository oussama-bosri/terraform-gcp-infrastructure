resource "google_storage_bucket" "backend_bucket" {
  name                        = var.bucket_name
  location                    = var.location
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30
    }
  }
}
