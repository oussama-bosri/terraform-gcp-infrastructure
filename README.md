# gcp-storage-terraform

A modular Terraform project to provision Google Cloud Platform (GCP) infrastructure for DevOps labs, including:
- Google Cloud Storage (GCS) bucket
- Service Account with storage permissions
- Compute Engine VMs for Jenkins, SonarQube, and Docker Swarm (with automated setup scripts)

---

## Project Structure

```
gcp-storage-terraform/
├── main.tf                    # Loads modules/providers
├── variables.tf               # Shared variables
├── terraform.tfvars           # Variable values (not committed)
├── outputs.tf                 # All outputs
├── backend.tf                 # GCS remote backend config
├── modules/
│   ├── gcs/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── service_account/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── compute/
│       ├── jenkins.tf
│       ├── sonarqube.tf
│       ├── docker.tf
│       ├── outputs.tf
│       └── variables.tf
├── scripts/
│   ├── install-jenkins.sh
│   ├── install-sonarqube.sh
│   └── install-docker-swarm.sh
└── README.md
```

---

## Features
- **GCS Bucket**: Versioned, lifecycle-managed storage for state or artifacts
- **Service Account**: IAM permissions for bucket access
- **Jenkins VM**: Automated install via startup script
- **SonarQube VM**: Automated install via startup script
- **Docker Swarm VM**: Automated install and initialization

---

## Prerequisites
- [Terraform](https://www.terraform.io/downloads.html) installed
- GCP project and billing enabled
- [gcloud CLI](https://cloud.google.com/sdk/docs/install) authenticated:
  ```sh
  gcloud auth application-default login
  gcloud config set project <your-project-id>
  ```

---

## Usage
1. **Clone the repository**
   ```sh
   git clone https://github.com/<your-username>/gcp-storage-terraform.git
   cd gcp-storage-terraform
   ```
2. **Edit `terraform.tfvars`** with your values:
   ```hcl
   project_id  = "your-gcp-project-id"
   bucket_name = "your-unique-bucket-name"
   ```
3. **Initialize Terraform**
   ```sh
   terraform init
   ```
4. **Review the plan**
   ```sh
   terraform plan
   ```
5. **Apply the configuration**
   ```sh
   terraform apply -auto-approve
   ```
6. **Check Outputs**
   - GCS bucket URL
   - Service account email
   - Public IPs for Jenkins, SonarQube, Docker Swarm VMs

---

## State Management
- State is stored remotely in a GCS bucket (see `backend.tf`).
- No local `.tfstate` files are committed.

---

## .gitignore Example
```
.terraform/
*.tfstate
*.tfstate.*
*.tfvars
crash.log
*.backup
*.json
*.b64
```

---

## Security Warning
**Important:** Never commit service account keys, credentials, or other secrets (such as `*.json`, `*.b64`, or files in `.ssh/`) to version control. Always keep these files secure and out of your repository. Use environment variables or secret managers for sensitive data.

---

## Notes
- Startup scripts for VMs are in the `scripts/` directory and run automatically on VM creation.
- To re-run a startup script, you must taint or recreate the VM resource.
- Firewall rules for Jenkins (8080), SonarQube (9000), and Docker Swarm (2377, 7946, 4789) may need to be configured in GCP.

---

## License
MIT (or your preferred license) 