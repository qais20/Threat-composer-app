# Application Load Balancer (ALB) configuration
resource "aws_lb" "app-lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.tm-sg.id]
  subnets            = [aws_subnet.tm-subnet.id, aws_subnet.tm-subnet2.id]

  enable_deletion_protection = false

}

# Target group for the application load balancer
resource "aws_lb_target_group" "tm-tg" {
  name        = "tm-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.app-vpc.id
  target_type = "ip"
}

# HTTP listener for the application load balancer
resource "aws_lb_listener" "tm_http" {
  load_balancer_arn = aws_lb.app-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "redirect"
    target_group_arn = aws_lb_target_group.tm-tg.arn

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# HTTPS listener for the application load balancer
resource "aws_lb_listener" "tm_https" {
  load_balancer_arn = aws_lb.app-lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:eu-west-2:009160072276:certificate/0285f2a5-5bb7-4c9c-ad71-2becf3df8f4f"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tm-tg.arn
  }
}


