provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_groups" "kodekloud_demo" {
    name = "kodekloud_demo"
    description = " kodekloud_demo security group"
    vpc_id = data.aws_vpc.default.vpc_id

    ingress {
        description = "Http access" 
        from_port = 80
        to_port = 80 
        ip_protocol = "tcp"
        cidr_ipv4 = ["0.0.0.0/0"]
    }
    ingress {
        description = "ssh"
        from_port = 22
        to_port = 22
        ip_protocol = "tcp"
        cidr_ipv4 = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0 
        ip_protocol = "-1"
        cidr_ipv4 = ["0.0.0.0/0"]
    }
}
