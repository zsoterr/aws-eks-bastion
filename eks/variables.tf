variable "aws_region" {
  default = "YOURREGION"
}

variable "aws_vpc" {
  type    = string
  default = "YOURVPC_ID"
}

variable "default_tags" {
  type = map(any)
  default = {
    "owner"      = "YOURNAME",
    "environment" = "dev",
   }
  description = "Default resource tags"
}

variable "subnets" {
  type = list(any)
}

variable "cluster_name" {
  type    = string
  default = "YOURNAME-eks-tf"
}

variable "account_id" {
  type    = string
  default = "YOURACCOUNT_ID"
}

variable "role_name" {
  type    = string
  default = "YOURNAME-eks-tf-bastion-role"
}