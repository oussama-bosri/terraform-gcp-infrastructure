output "jenkins_ip" {
  value = google_compute_instance.jenkins.network_interface[0].access_config[0].nat_ip
}

output "sonarqube_ip" {
  value = google_compute_instance.sonarqube.network_interface[0].access_config[0].nat_ip
}

output "docker_swarm_ip" {
  value = google_compute_instance.docker_swarm.network_interface[0].access_config[0].nat_ip
} 