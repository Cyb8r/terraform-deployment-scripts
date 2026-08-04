resource "aws_vpc" "web-infra-vpc" {
    cidr_block = "172.0.0.0/16"
    enable_dns_support = true  
}

resource "aws_subnet" "web-infra-public-subnet" {
    vpc_id = aws_vpc.web-infra-vpc.id
    cidr_block = "172.0.0.0/24"
    map_public_ip_on_launch = true
  
}

resource "aws_subnet" "web-infra-private-subnet" {
    vpc_id = aws_vpc.web-infra-vpc.id
    cidr_block = "172.0.1.0/24"
}

resource "aws-subnet" "web-infra-private-subnet-2" {
    vpc_id = aws_vpc.web-infra-vpc.id
    cidr_block = "172.0.2.0/24"
}

resource "aws_alb" "web-infra-alb" {
    name = "web-infra-alb"
    internal = false
    security_groups = [aws_security_group.web-infra-sg.id]
    subnets = [aws_subnet.web-infra-public-subnet.id]
}

resource "aws_security_group" "web-infra-sg" {
    name = "web-infra-sg"
    description = "Security group for web infrastructure"
    vpc_id = aws_vpc.web-infra-vpc.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }   

}

resource "aws_lb_target_group" "web-infra-tg" {
  name = "web-infra-tg"
  target_type = "alb"
    port = 80
    protocol = "tcp"
    vpc_id = aws_vpc.web-infra-vpc.id
}
