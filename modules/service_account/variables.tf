variable "account_id" {
  description = "Service account ID"
  type        = string
}

variable "display_name" {
  description = "Service account display name"
  type        = string
}

variable "bucket_name" {
  description = "Name of the GCS bucket to grant access"
  type        = string
}
