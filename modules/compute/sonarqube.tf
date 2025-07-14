resource "google_compute_address" "sonarqube_ip" {
  name   = "${var.sonarqube_name}-ip"
  region = "us-central1"
}

resource "google_compute_instance" "sonarqube" {
  name         = var.sonarqube_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.sonarqube_ip.address
    }
  }

  tags = ["sonarqube"]

  metadata_startup_script = file("${path.module}/../../scripts/install-sonarqube.sh")
}
