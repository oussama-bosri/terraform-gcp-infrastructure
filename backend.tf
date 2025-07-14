terraform {
  backend "gcs" {
    bucket  = "tfstate-devops-465809"
    prefix  = "terraform/state"
  }
} 