variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "availability_zone_public" {
  description = "Availability zone for the public subnet"
  type        = string
}

variable "availability_zone_private" {
  description = "Availability zone for the private subnet"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR for public subnet"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR for private subnet"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "bastion_key_pair_name" {
  description = "Name of the key pair for the bastion host"
  type        = string
}

variable "private_ec2_key_pair_name" {
  description = "Name of the key pair for the private EC2 instance"
  type        = string
  
}