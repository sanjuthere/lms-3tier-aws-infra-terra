variable "region" {
  description = "Provide Region"
  type        = string
}
variable "vpc_cidr" {
  description = "Provide CIDR"
  type        = string
}
variable "public_subnet_cidr_a" {
  description = "Provide subnet"
  type        = string
}
variable "private_subnet_cidr_a" {
  description = "Provide subnet"
  type        = string
}
variable "public_subnet_cidr_b" {
  description = "Provide subnet"
  type        = string
}
variable "private_subnet_cidr_b" {
  description = "Provide subnet"
  type        = string
}
variable "instance_type" {
  description = "Provide subnet"
  type        = string
}
variable "key_name" {
  description = "Key pair for SSH access"
  type        = string
}
variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

