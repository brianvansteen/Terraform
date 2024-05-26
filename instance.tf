# resource "aws_instance" "example" {
#   ami           = "ami-04ff98ccbfa41c9ad"
#   instance_type = "t2.micro"
# }


data "template_file" "user_data" {
  template = file("./userdata.yaml")
}

data "aws_vpc" "main" {
  id = "vpc-da5530bc"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/XXe01KWd/Ah6M0uYTTmHoWmZq+JtJfygXKx1BxhTs9E/CyUeahPWzJZLV7kTH8eZkVjDe8oK0rF6Mwi/RZ1C12QG4MjuB3pMnZD+pXUKkTFPFZnk7CY7qcr4zeZ2qJoQQT0NZw392NtcYo/doYMuC1fFHoDzo3EmV0vXeyXAOpMI9SpCguaBrXh4ZaBxAfByqhws91XoY5zjOK5BWHZUsOCxppS+JtLGMM/sFNId/9gbAo5hy0nsjo4zuP8dPnaJsBFGhjLSCO7PD41I3h5uu8e5hmxw/jziPLaGER5qo6vV/dbHmWSI45HdB5sUEoYrKBbZV7OOd0S2UVbsoeAqmmYVszpJ7GdzfamITGzd0b3uNUJLoVZ4+aX8FRkPCZMv8Z6NwuZ9+0PkmPuX3n6S795mdTIxYqTbOG/5HU9Q+xCTCh1jgfn8DmEc4TPdg8fw+TMxENsGWyxtR1KasSmAxFvIWoM5Y94njjCZEZMt67y/GQLH4cqdE06jDC3SToU= bvans@Coding"
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.main.id
  ingress = [
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = ["sg-a77e10db"]
      self             = false
    },
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["198.54.132.189/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = ["sg-a77e10db"]
      self             = false
    }
  ]
  egress = [
    {
      description      = "all"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = ["sg-a77e10db"]
      self             = false
    }
  ]
  tags = {
    Name = "allow_tls"
  }
}

# ssh ec2-user@$(terraform output -raw public_ip) -i terraform

resource "aws_instance" "web_server" {
  ami                    = "ami-04ff98ccbfa41c9ad"
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  user_data              = data.template_file.user_data.rendered
  tags = {
    Name    = "WebServer"
    Project = "Project-${local.project_name}"
  }
  # provisioner "remote-exec" {
  #   inline = [ "echo ${self.private_dns} >> /home/ec2-user/privateDNS.txt" ]
  #   connection {
  #     type = "ssh"
  #     user = "ec2-user"
  #     host = "${self.public_ip}"
  #     private_key = "${file("terraform")}"
  #   }
  # }
  provisioner "file" {
    content = "mars"
    destination = "/home/ec2-user/barsoon.txt"
    connection {
      type = "ssh"
      user = "ec2-user"
      host = "${self.public_ip}"
      private_key = "${file("terraform")}"
    }
  }

  # provisioner "local-exec" {
  #   command = "echo ${self.private_ip} >> privateIP.txt"
  # }
}

# resource "null_resource" "status" {
#   provisioner "local-exec" {
#     command = "aws ec2 wait instance-status-ok --instance-ids ${aws_instance.web_server.id}"
#   }
#   depends_on = [ aws_instance.web_server ]
# }

resource "terraform_data" "status" {
  provisioner "local-exec" {
    command = "aws ec2 wait instance-status-ok --instance-ids ${aws_instance.web_server.id}"
  }
  depends_on = [ aws_instance.web_server ]
}

# resource "aws_security_group_rule" "ingress_http" {
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   cidr_blocks       = [data.aws_vpc.main.cidr_block]
#   ipv6_cidr_blocks  = []
#   security_group_id = "sg-123456"
# }

# resource "aws_security_group_rule" "egress_http" {
#   type              = "egress"
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = ["0.0.0.0/0"]
#   prefix_list_ids   = []
#   from_port         = 0
#   security_group_id = "sg-123456"
# }


# module "vpc" {
#   source = "terraform-aws-modules/vpc/aws"
#   providers = {
#     aws = aws.eu
#   }

#   name = "my-vpc"
#   cidr = "10.0.0.0/16"

#   azs             = ["eu-west-1a", "eu-west-1b"]
#   private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
#   public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

#   enable_nat_gateway = false
#   enable_vpn_gateway = false

#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }