variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr_a" {
  description = "CIDR block for the private subnet in AZ a"
  type        = string
}

variable "private_subnet_cidr_b" {
  description = "CIDR block for the private subnet in AZ b"
  type        = string
}

variable "key_name" {
  description = "Key pair for SSH access"
}

variable "instance_type" {
  default = "t2.micro"
}
