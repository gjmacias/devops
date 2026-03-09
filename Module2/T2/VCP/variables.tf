variable "key_name_bastion" {
    description = "SSH key pair name for bastion host"
    type        = string
}

variable "key_name_private" {
    description = "SSH key pair name for private EC2 instance"
    type        = string
}