# Genera un par de claves RSA
resource "tls_private_key" "bastion" {
    algorithm = "ED25519"
}

resource "tls_private_key" "private_ec2" {
    algorithm = "ED25519"
}


# Create key pair for Bastion in AWS
resource "aws_key_pair" "bastion" {
    key_name   = "bastion-key"
    public_key = tls_private_key.bastion.public_key_openssh
}

# Create key pair for private instance in AWS
resource "aws_key_pair" "private_ec2" {
    key_name   = "private-key"
    public_key = tls_private_key.private_ec2.public_key_openssh
}


resource "local_file" "bastion_private_key" {
    content  = tls_private_key.bastion.private_key_pem
    filename = "${path.module}/bastion-key.pem"
    file_permission = "0600"
}

resource "local_file" "private_ec2_private_key" {
    content  = tls_private_key.private_ec2.private_key_pem
    filename = "${path.module}/private-key.pem"
    file_permission = "0600"
}