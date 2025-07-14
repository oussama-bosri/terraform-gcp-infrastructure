resource "google_compute_address" "jenkins_ip" {
  name   = "${var.jenkins_name}-ip"
  region = "us-central1"
}

resource "google_compute_instance" "jenkins" {
  name         = var.jenkins_name
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
      nat_ip = google_compute_address.jenkins_ip.address
    }
  }

  tags = ["jenkins"]

  metadata_startup_script = file("${path.module}/../../scripts/install-jenkins.sh")
}
