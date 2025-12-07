# terraform-azure-project
## Infrastructure-as-Code deployment of a scalable 3-tier web application on Microsoft Azure using Terraform

### This project provisions a production-ready Azure environment using Terraform, including:

- Virtual Network with public, private, and data subnets

- Linux Virtual Machine Scale Set behind a Load Balancer

- Secure PostgreSQL Flexible Server with private networking

- Azure Key Vault for secret storage

- Network Security Groups with strict traffic rules

- Centralized monitoring using Log Analytics + Azure Monitor Diagnostic Settings

- GitHub Actions CI pipeline for Terraform (fmt + validate)

- This repository is structured for multi-environment deployments (dev/prod) and follows Terraform best practices using reusable modules.
