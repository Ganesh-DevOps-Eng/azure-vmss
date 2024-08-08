variable "location" {
  description = "Azure region for the resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}


variable "private_subnet_a_id" {
  description = "Subnet ID for the virtual machine"
  type        = string
}
variable "private_subnet_b_id" {
  description = "Subnet ID for the virtual machine"
  type        = string
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the VM"
  type        = string
}

variable "virtual_network_id" {
  description = "virtual_network_address space"
  type        = string
}

variable "vm_count" {
  description = "Number of VMs in the scale set"
  default     = 2
}