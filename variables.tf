variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
  default     = "pilotVNet"
}

variable "address_space" {
  description = "Address space for the Virtual Network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "location" {
  description = "Azure region for the resources"
  type        = string
  default     = "eastus2"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "pilot"
}

variable "public_subnet_name" {
  description = "Name of the public subnet"
  type        = string
  default     = "publicSubnet"
}

variable "public_subnet_prefix" {
  description = "Address prefix for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_a_name" {
  description = "Name of the first private subnet"
  type        = string
  default     = "privateSubnetA"
}

variable "private_subnet_a_prefix" {
  description = "Address prefix for the first private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_b_name" {
  description = "Name of the second private subnet"
  type        = string
  default     = "privateSubnetB"
}

variable "private_subnet_b_prefix" {
  description = "Address prefix for the second private subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "adminuser"
}

variable "admin_password" {
  description = "Admin password for the VM"
  type        = string
  default     = "P@ssw0rd1234"
}

variable "dns_name" {
  description = "DNS name for the Bastion Host"
  type        = string
  default     = "myBastion"
}