variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr_a" {
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr_a" {
  default = "10.0.2.0/24"
}

variable "public_subnet_cidr_b" {
  default = "10.0.3.0/24"
}

variable "private_subnet_cidr_b" {
  default = "10.0.4.0/24"
}

variable "key_name" {
  description = "Key pair for SSH access"
}

variable "instance_type" {
  default = "t2.micro"
}
