variable "jenkins_name" {
  description = "Name of the Jenkins VM"
  type        = string
  default     = "jenkins-vm"
}

variable "sonarqube_name" {
  description = "Name of the SonarQube VM"
  type        = string
  default     = "sonarqube-vm"
}

variable "docker_name" {
  description = "Name of the Docker Swarm VM"
  type        = string
  default     = "docker-swarm-vm"
}

variable "machine_type" {
  description = "Machine type for all VMs"
  type        = string
  default     = "e2-medium"
}

variable "image" {
  description = "Image for all VMs"
  type        = string
  default     = "debian-cloud/debian-11"
}

variable "zone" {
  description = "Zone for all VMs"
  type        = string
  default     = "us-central1-a"
}
