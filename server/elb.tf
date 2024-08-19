resource "aws_lb" "main" {
  name               = "${var.environment}-main-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sh_sg_for_elb.id]
  subnets            = [aws_subnet.sh_subnet_1.id, aws_subnet.sh_subnet_1a.id]
  depends_on         = [aws_internet_gateway.sh_gw]
}

resource "aws_lb_target_group" "app1" {
  name     = "${var.environment}-app1-tg"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = aws_vpc.sh_main.id
}

resource "aws_lb_target_group" "app2" {
  name     = "${var.environment}-app2-tg"
  port     = 8002
  protocol = "HTTP"
  vpc_id   = aws_vpc.sh_main.id
}
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: Not Found"
      status_code  = "404"
    }
  }
}

# Rule for app1 - path /app1/*
resource "aws_lb_listener_rule" "app1" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app1.arn
  }

  condition {
    path_pattern {
      values = ["/rds/*"]
    }
  }
}

# Rule for app2 - path /app2/*
resource "aws_lb_listener_rule" "app2" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app2.arn
  }

  condition {
    path_pattern {
      values = ["/redis/*"]
    }
  }
}
