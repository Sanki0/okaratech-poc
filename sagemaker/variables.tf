variable "tags" {
  description = "Optional - AWS Tags to be added to all the resources created within the module"
  default     = {}
}

##################################################################
# General variables
##################################################################

variable "region" {
  description = "The AWS region to deploy the resources"
  type        = string  
}

variable "prefix_resource_name" {
  description = "Required - the prefix name is used to name the resources {coid}-{assetid}-{appid} or applying-000-terraform"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.prefix_resource_name))
    error_message = "The prefix_resource_name value must be lowercase!"
  }
}

variable "app_name" {
  description = "The app_name, it must be unique and lower case."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.app_name))
    error_message = "The app_name value must be lowercase!"
  }
}

variable "vpc_id" {
  description = "The VPC id"
  type        = string
}

variable "subnet_private_list"{
  description = "The list of private subnet ids"
  type = list(string)
}