
# Create a module to create the VPC, subnets, internet gateway, NAT gateway, route tables, and security groups
# The module will be called "infra" and will be located in the "modules" directory
# The module will take the following variables as input
module "infra" {
    source = "./modules"

    instance_type       = var.instance_type
    aws_region          = var.aws_region
    vpc_cidr            = var.vpc_cidr
    public_subnet_cidr  = var.public_subnet_cidr
    private_subnet_cidr = var.private_subnet_cidr
}