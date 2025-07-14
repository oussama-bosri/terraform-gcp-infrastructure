resource "google_compute_address" "docker_swarm_ip" {
  name   = "${var.docker_name}-ip"
  region = "us-central1"
}

resource "google_compute_instance" "docker_swarm" {
  name         = var.docker_name
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
      nat_ip = google_compute_address.docker_swarm_ip.address
    }
  }

  tags = ["docker-swarm"]

  metadata_startup_script = file("${path.module}/../../scripts/install-docker-swarm.sh")
}
