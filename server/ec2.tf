

# ASG with Launch template
resource "aws_launch_template" "sh_ec2_launch_templ" {
  name_prefix   = "${var.environment}-sh_ec2_launch_templ"
  image_id      = var.ami_id #specific for each region
  instance_type = var.instance_type
  user_data     = filebase64("${path.module}/user_data.sh")

  network_interfaces {
    associate_public_ip_address = false
    subnet_id                   = aws_subnet.sh_subnet_2.id
    security_groups             = [aws_security_group.sh_sg_for_ec2.id]
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.environment}-instance"
    }
  }
}

resource "aws_autoscaling_group" "sh_asg" {
  # no of instances
  desired_capacity = 1
  max_size         = 1
  min_size         = 1

  # source
  target_group_arns = [aws_lb_target_group.app1.arn,aws_lb_target_group.app2.arn]

  vpc_zone_identifier = [ # use private subnet
    aws_subnet.sh_subnet_2.id
  ]

  launch_template {
    id      = aws_launch_template.sh_ec2_launch_templ.id
    version = "$Latest"
  }
}

# 502 error when instance is in private subnet w/ nat gateway
# https://stackoverflow.com/a/53861750
# 502 - Probably Apache/Server not running b/c it’s not installed because there's no nat gw or method to install software.