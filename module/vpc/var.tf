variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
}

variable "address_space" {
  description = "Address space for the Virtual Network"
  type        = list(string)
}

variable "location" {
  description = "Azure region for the resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "public_subnet_name" {
  description = "Name of the public subnet"
  type        = string
}

variable "public_subnet_prefix" {
  description = "Address prefix for the public subnet"
  type        = string
}

variable "private_subnet_a_name" {
  description = "Name of the first private subnet"
  type        = string
}

variable "private_subnet_a_prefix" {
  description = "Address prefix for the first private subnet"
  type        = string
}

variable "private_subnet_b_name" {
  description = "Name of the second private subnet"
  type        = string
}

variable "private_subnet_b_prefix" {
  description = "Address prefix for the second private subnet"
  type        = string
}
