variable "aws_region" {
  description = "Region for the VPC"
  default     = "eu-central-1"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default     = "192.168.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default     = "192.168.1.0/24"
}

variable "wb_ami" {
  description = "ubuntu 18"
  default     = "ami-03818140b4ac9ae2b"
}

variable "key_path" {
  description = "SSH Public Key path"
  default     = "/Users/yaa/.ssh/id_rsa.pub"
}

variable "identity" {
  type    = string
  default = "yaa-test"
}

variable "default_tags" {
  type = map
  default = {
    "environment" : "sandbox",
    "owner" : "vsevolod.suzdaltsev"
  }
}
