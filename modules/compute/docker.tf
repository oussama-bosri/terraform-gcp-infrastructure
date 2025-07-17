resource "google_compute_address" "docker_swarm_manager_ip" {
  name   = "${var.docker_manager_name}-ip"
  region = "us-central1"
}

resource "google_compute_instance" "docker_swarm_manager" {
  name         = var.docker_manager_name
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
      nat_ip = google_compute_address.docker_swarm_manager_ip.address
    }
  }

  tags = ["docker-swarm-manager"]

  metadata_startup_script = file("${path.module}/../../scripts/install-docker-swarm-manager.sh")
}

resource "google_compute_address" "docker_swarm_worker_ip" {
  name   = "${var.docker_worker_name}-ip"
  region = "us-central1"
}

resource "google_compute_instance" "docker_swarm_worker" {
  name         = var.docker_worker_name
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
      nat_ip = google_compute_address.docker_swarm_worker_ip.address
    }
  }

  tags = ["docker-swarm-worker"]

  metadata = {
    join_command = google_compute_instance.docker_swarm_manager.network_interface[0].access_config[0].nat_ip
  }

  metadata_startup_script = file("${path.module}/../../scripts/install-docker-swarm-worker.sh")
}

resource "google_compute_firewall" "jenkins" {
  name    = "allow-jenkins"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  target_tags = ["jenkins"]
  direction   = "INGRESS"
  description = "Allow external access to Jenkins UI"
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "jenkins_https" {
  name    = "allow-jenkins-https"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  target_tags = ["jenkins"]
  direction   = "INGRESS"
  description = "Allow external HTTPS access to Jenkins"
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "swarm_web" {
  name    = "allow-swarm-web"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080"]
  }

  target_tags = ["docker-swarm-manager", "docker-swarm-worker"]
  direction   = "INGRESS"
  description = "Allow external access to Swarm web services"
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "sonarqube" {
  name    = "allow-sonarqube"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9000"]
  }

  target_tags = ["jenkins"]
  direction   = "INGRESS"
  description = "Allow external access to SonarQube UI"
  source_ranges = ["0.0.0.0/0"]
}
