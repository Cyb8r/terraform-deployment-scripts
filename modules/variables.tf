variable "ec2_web_infra_server" {
    description = "The EC2 instance for the web infrastructure server"
    type        = string
    default     = "web-infra-server"
}

variable "ami" {
    description = "The AMI ID for the EC2 instance"
    type        = string
    default     = "ami-00adafae70b8029d8" # Amazon Linux 2 AMI
}

variable "instance_type" {
    description = "The instance type for the EC2 instance"
    type        = string
    default     = "t3.micro"
}