output "bucket_url" {
  value = module.gcs.bucket_url
}

output "service_account_email" {
  value = module.service_account.service_account_email
} 