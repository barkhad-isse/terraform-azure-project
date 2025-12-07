variable "resource_group_name" {
  type        = string
  description = "Name of the resource group where compute resources will be created."
}

variable "location" {
  type        = string
  description = "Azure region for compute resources."
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID where the VMSS instances will be placed (web/public subnet)."
}

variable "environment" {
  type        = string
  description = "Deployment environment (dev, prod, etc)."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all compute resources."
}

variable "vmss_sku" {
  type        = string
  description = "VM size for VM scale set instances."
}

variable "instance_count" {
  type        = number
  description = "Initial number of instances in the VMSS."
}

variable "instance_min" {
  type        = number
  description = "Minimum instance count for autoscaling (will be used later)."
}

variable "instance_max" {
  type        = number
  description = "Maximum instance count for autoscaling (will be used later)."
}

variable "admin_username" {
  type        = string
  description = "Admin username for Linux VMs."
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for the VMSS instances."
  sensitive   = true
}

variable "app_port" {
  type        = number
  description = "Port on which NGINX will listen."
  default     = 80
}
