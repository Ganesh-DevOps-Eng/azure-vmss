variable "location" {
  description = "Azure region for the resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the Bastion Host"
  type        = string
}


variable "dns_name" {
  description = "DNS name for the Bastion Host"
  type        = string
}
