# Genera un par de claves RSA
resource "tls_private_key" "public_ec2" {
    algorithm = "RSA"
    rsa_bits  = 4096
}

# Create key pair for public instance in AWS
resource "aws_key_pair" "public_ec2" {
    key_name   = "public-key"
    public_key = tls_private_key.public_ec2.public_key_openssh
}

resource "local_file" "public_ec2_private_key" {
    content  = tls_private_key.public_ec2.private_key_pem
    filename = "${path.module}/${var.public_ec2_key_pair_name}.pem"
    file_permission = "0600"
}