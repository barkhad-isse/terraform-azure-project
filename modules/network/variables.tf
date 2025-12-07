variable "resource_group_name" {
  type        = string
  description = "Name of the resource group where network resources will be created."
}

variable "location" {
  type        = string
  description = "Azure region for network resources."
}

variable "address_space" {
  type        = list(string)
  description = "Address space for the virtual network."
}

variable "subnet_prefixes" {
  description = "CIDR prefixes for the three subnets."
  type = object({
    public  = string
    private = string
    data    = string
  })
}

variable "allowed_ssh_from" {
  type        = string
  description = "CIDR for SSH access to web tier (e.g. your IP /32)."
}

variable "environment" {
  type        = string
  description = "Deployment environment (dev, prod, etc)."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all network resources."
}
