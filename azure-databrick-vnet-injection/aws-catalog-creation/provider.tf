terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = ">= 1.81.0"
    }
    aws = {
      source = "hashicorp/aws"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "databricks" {
  alias      = "workspace"
  host       = var.workspace_host
  client_id  = var.client_id
  client_secret = var.client_secret
}


