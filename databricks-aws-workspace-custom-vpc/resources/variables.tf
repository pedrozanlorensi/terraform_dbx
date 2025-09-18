variable "databricks_account_id" {
  description = "ID of the Databricks account."
  type        = string
  sensitive   = true
}

variable "client_id" {
  description = "Client ID for Databricks authentication."
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "Secret key for the Databricks client ID."
  type        = string
  sensitive   = true
}

variable "prefix" {
  description = "Prefix for resource names."
  type        = string
}

variable "resource_prefix" {
  description = "Prefix for naming AWS resources."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-.]{1,40}$", var.resource_prefix))
    error_message = "Invalid resource prefix. Allowed 40 characters containing only a-z, 0-9, -, ."
  }
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
  default     = {}
}

variable "region" {
  description = "AWS region code."
  type        = string
  validation {
    condition     = contains(["ap-northeast-1", "ap-northeast-2", "ap-south-1", "ap-southeast-1", "ap-southeast-2", "ca-central-1", "eu-central-1", "eu-west-1", "eu-west-2", "eu-west-3", "sa-east-1", "us-east-1", "us-east-2", "us-west-2"], var.region)
    error_message = "Valid values for var.region are standard AWS regions supported by Databricks."
  }
}

variable "vpc_cidr_range" {
  description = "CIDR range for the VPC."
  type        = string
}

variable "availability_zones" {
  description = "List of AWS availability zones."
  type        = list(string)
}

variable "private_subnets_cidr" {
  description = "List of private subnet CIDR blocks."
  type        = list(string)
}

variable "public_subnets_cidr" {
  description = "List of public subnet CIDR blocks."
  type        = list(string)
}

variable "sg_egress_ports" {
  description = "List of egress ports for security groups."
  type        = list(number)
}

variable "security_group_ids"{
    description = "Security group ids"
    type = list(string)
    default = []
}

variable "subnet_ids"{
    description = "Subnet ids"
    type = list(string)
    default = []
}

variable "vpc_id"{
    description = "VPC id"
    type = string
    default = ""
}

variable "metastore_id" {
  description = "Metastore id"
  type = string
}

variable "metastore_name" {
  description = "Metastore name"
  type = string
}

variable "metastore_owner_usernames" {
  description = "List of usernames that will have owner access to the metastore"
  type        = list(string)
  default     = []
}

variable "metastore_owners_group_name" {
  description = "Name of the group that will own the metastore"
  type        = string
  default     = "metastore-owners"
}

variable "workspace_admin_usernames" {
  description = "List of usernames that will have admin access to the workspace"
  type        = list(string)
  default     = []
}

variable "workspace_admins_group_name" {
  description = "Name of the group that will have admin access to the workspace"
  type        = string
  default     = "workspace-admins"
}