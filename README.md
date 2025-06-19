# DIEVOPS Platform Infrastructure

## Project Overview
Infrastructure as Code (IaC) repository for managing GCP infrastructure and Kubernetes configurations using Terraform Cloud and GitOps practices.

## Architecture
For detailed architecture diagrams and workflow explanations, see [Architecture Documentation](docs/architecture.md).

## Current Structure
```
platform-root/
├── docs/
│   └── architecture.md   # Architecture diagrams and documentation
├── infra-gcp/
│   ├── modules/          # Terraform modules (pending)
│   └── envs/
│       └── dev/         # Development environment
│           ├── backend.tf  # Terraform Cloud configuration
│           └── main.tf     # Base GCP provider setup
├── cluster-config/      # Kubernetes configurations
│   ├── base/           # Base configurations (pending)
│   └── overlays/       # Environment-specific overlays (pending)
└── .gitignore          # Git ignore patterns for Terraform
```

## Environment Configuration

### Development Environment
- **Project ID**: dievops-dev
- **Region**: us-central1
- **Terraform Cloud Workspace**: dievops-dev

## Prerequisites
- Google Cloud SDK
- Terraform CLI
- Terraform Cloud Account
- GCP Project with required APIs enabled

## Current Setup Status
- [x] Basic repository structure
- [x] Terraform Cloud backend configuration
- [x] GCP provider configuration
- [x] Development environment basic setup
- [ ] Terraform modules implementation
- [ ] Kubernetes configurations
- [ ] CI/CD pipelines

## Getting Started
1. Ensure you have the required prerequisites
2. Set up Terraform Cloud token:
   ```bash
   export TF_TOKEN_app_terraform_io="your-token"
   ```
3. Initialize Terraform:
   ```bash
   cd infra-gcp/envs/dev
   terraform init
   ```

## Next Steps
1. Implement core Terraform modules:
   - GKE cluster
   - Networking
   - Gateway API
2. Set up Kubernetes base configurations
3. Configure CI/CD pipelines
4. Implement production environment 