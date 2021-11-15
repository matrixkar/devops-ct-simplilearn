provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_security_group" "security-group-01" {
  name        = "security-group-01"
  description = "Allow port 22 for ssh connect"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    
  egress {
    from_port	= 0
    to_port 	= 0
    protocol	= "-1"
    cidr_blocks	= ["0.0.0.0/0"]
  }
}

resource "aws_instance" "instance" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "cttraining"
  subnet_id = "${var.public_subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.security-group-01.id}"]
    
  tags = {
    Name = "hsbc06"
  }
}
