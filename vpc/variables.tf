variable "tags" {
  description = "Optional - AWS Tags to be added to all the resources created within the module"
  default     = {}
}

##################################################################
# General variables
##################################################################

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

variable "vpc_cidr" {
  description = "The EMR release label to use for the cluster"
  type        = string  
}

variable "availability_zones" {
  description = "The availability zones to use for the cluster"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
}