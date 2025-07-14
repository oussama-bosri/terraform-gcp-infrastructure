output "jenkins_ip" {
  value = google_compute_instance.jenkins.network_interface[0].access_config[0].nat_ip
}

output "docker_swarm_manager_ip" {
  value = google_compute_instance.docker_swarm_manager.network_interface[0].access_config[0].nat_ip
}

output "docker_swarm_worker_ip" {
  value = google_compute_instance.docker_swarm_worker.network_interface[0].access_config[0].nat_ip
} 