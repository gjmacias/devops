# variables.tf
# This file defines the variables that will be used in the main.tf file 
# to create the VPC, subnets, internet gateway, NAT gateway, route tables, and security groups
# also is in the modules directory and is used to define the variables that will be used
variable "aws_region" {}
variable "availability_zone_public" {}
variable "availability_zone_private" {}
variable "instance_type" {}
variable "vpc_cidr" {}
variable "public_subnet_cidr" {}
variable "private_subnet_cidr" {}
variable "bastion_key_pair_name" {}
variable "private_ec2_key_pair_name" {}