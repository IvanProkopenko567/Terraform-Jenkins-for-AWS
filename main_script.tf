provider "aws" {

        region = "eu-central-1"
}

resource "aws_instance" "my_webserver" {
        ami = "ami-0767046d1677be5a0"
        instance_type = "t2.micro"
        vpc_security_group_ids = [aws_security_group.my_webserver.id]


connection  {
    host= self.public_ip
    type = "ssh"
    user = "ubuntu"
    private_key = file("aws_key.pem")
  }

  provisioner "file" {
   source      = "script.sh"
   destination = "script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x script.sh",
      "sudo bash ./script.sh",
    ]
  }
	

        key_name = "aws_key"

}




resource "aws_security_group" "my_webserver" {
  name        = "Webserver security group"
  description = "My first group"


  ingress {

    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my_HW_1"
  }
}

