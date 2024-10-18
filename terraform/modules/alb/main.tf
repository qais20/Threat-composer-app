# Application Load Balancer (ALB) configuration
resource "aws_lb" "app-lb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.subnet_ids

  enable_deletion_protection = false

}

# Target group for the application load balancer
resource "aws_lb_target_group" "tm-tg" {
  name        = "tm-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

# HTTP listener for the application load balancer
resource "aws_lb_listener" "tm_http" { #ecs is holding the var
  load_balancer_arn = aws_lb.app-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "redirect"
    target_group_arn = aws_lb_target_group.tm-tg.arn #maybe here

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# HTTPS listener for the application load balancer
resource "aws_lb_listener" "tm_https" { #ecs is holding the var
  load_balancer_arn = aws_lb.app-lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tm-tg.arn #maybe here
  }
}


