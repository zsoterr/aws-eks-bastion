variable "aws_region" {
  type    = string
  default = "YOURREGION"
}

variable "cluster_name" {
  type        = string
  default     = "YOURNAME-eks-tf"
  description = "Name of the cluster"
}


variable "bastion_name" {
  type        = string
  default     = "bastion_host"
  description = "Name of the bastion instance"
}

variable "vpc" {
  description = "VPC of Bastion host"
  type        = string
}


variable "subnets_pub" {
  description = "Public Subnets"
  type        = list(string)
}

variable "keypair_name" {
  type        = string
  default     = "bastion-eks-keypair"
  description = "Generated key pair meanwhile deployment"
}

variable "secret_private_key_name" {
  type        = string
  default     = "bastion-eks-private_key"
  description = "Private key of bastion-eks-keypair"
}


variable "sg_bastion_ing_source" {
  description = "Source IP address which is able to reach bastion host"
  type        = string
  default     = "YOUR_PUBLIC_IP"
}

variable "instance_type" {
  type    = list(any)
  default = ["t2.micro", "t3.micro", "t3.micro"]
}