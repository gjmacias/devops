# variables.tf
# This file defines the variables that will be used in the main.tf file 
# to create the VPC, subnets, internet gateway, NAT gateway, route tables, and security groups
# also is in the modules directory and is used to define the variables that will be used
variable "instance_type" {}
variable "aws_region" {}
variable "vpc_cidr" {}
variable "public_subnet_cidr" {}
variable "private_subnet_cidr" {}