resource "aws_launch_template" "ec2_web_infra_server" {
  name_prefix   = "web-infra-server-"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.web_key.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.web.id]
    subnet_id                   = aws_subnet.public.id
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install -y nginx1
              sudo systemctl start nginx
              sudo systemctl enable nginx
          EOF

  lifecycle {
    create_before_destroy = true
  }
  
}

resource "aws_autoscaling_group" "web_infra_asg" {
  name                      = "web-infra-asg"
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 2
  vpc_zone_identifier       = [aws_subnet.private.id]
  launch_template {
    id      = aws_launch_template.ec2_web_infra_server.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "web-infra-server"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_scaling_policy" "web_infra_scale_up" {
  name                   = "web-infra-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web_infra_asg.name
}

