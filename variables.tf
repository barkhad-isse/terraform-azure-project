variable "project_name" {
  type        = string
  description = "Base name used for resource naming."
  default     = "terraform-azure-webapp"
}

variable "environment" {
  type        = string
  description = "Deployment environment name (e.g. dev, prod)."
}

variable "location" {
  type        = string
  description = "Azure region for all resources."
  default     = "switzerlandnorth"
}

variable "address_space" {
  type        = list(string)
  description = "Address space for the virtual network."
  default     = ["10.0.0.0/16"]
}

variable "subnet_prefixes" {
  description = "CIDR prefixes for the three subnets."
  type = object({
    public  = string
    private = string
    data    = string
  })
  default = {
    public  = "10.0.1.0/24"
    private = "10.0.2.0/24"
    data    = "10.0.3.0/24"
  }
}

variable "allowed_ssh_source_ip" {
  type        = string
  description = "Your public IP/CIDR to allow SSH access from (e.g. 203.0.113.10/32)."
}

variable "vmss_instance_count" {
  type        = number
  description = "Initial number of instances in the VMSS."
  default     = 2
}

variable "vmss_instance_min" {
  type        = number
  description = "Minimum number of instances for autoscaling."
  default     = 2
}

variable "vmss_instance_max" {
  type        = number
  description = "Maximum number of instances for autoscaling."
  default     = 5
}

variable "vmss_sku" {
  type        = string
  description = "VM size for VM scale set instances."
  default     = "Standard_B2s"
}

variable "admin_username" {
  type        = string
  description = "Admin username for Linux VMs."
  default     = "azureadmin"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key used for the VMSS instances."
  sensitive   = true
}

variable "postgresql_version" {
  type        = string
  description = "Version for Azure Database for PostgreSQL flexible server."
  default     = "16"
}

variable "postgresql_sku_name" {
  type        = string
  description = "SKU name for PostgreSQL (for example B_Standard_B1ms)."
  default     = "B_Standard_B1ms"
}

variable "postgresql_storage_mb" {
  type        = number
  description = "Storage size for PostgreSQL in MB."
  default     = 32768
}

variable "postgresql_admin_username" {
  type        = string
  description = "Admin username for the PostgreSQL flexible server."
  default     = "pgadmin"
}

variable "postgresql_database_name" {
  type        = string
  description = "Name of the main application database."
  default     = "appdb"
}


variable "tags" {
  type        = map(string)
  description = "Additional tags to apply to all resources."
  default = {
    owner   = "CHANGE_ME"
    project = "terraform-azure-project"
  }
}
