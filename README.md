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

## Architecture Overview

<img width="500" height="600" alt="architec" src="https://github.com/user-attachments/assets/60602737-0dde-4dbf-9a75-35f745a9e3b1" />

## Features
### Infrastructure

- Highly structured Terraform module layout

- Fully private database tier

- Customizable VMSS scaling

- SSH access restricted to a single admin IP

- Secrets stored securely in Azure Key Vault

### Security

- NSGs enforcing strict east–west and north–south rules

- PostgreSQL private access only (no public endpoint)

- Randomized admin passwords via Terraform

### Monitoring

- Log Analytics Workspace

#### Azure Monitor Diagnostic Settings for:

- VM Scale Set

- Load Balancer

- NSGs

- Key Vault

### CI/CD

#### GitHub Actions workflow terraform-dev.yml runs automatically on every commit:

- terraform fmt -check

- terraform init

terraform validate

This ensures clean, stable, validated IaC.
