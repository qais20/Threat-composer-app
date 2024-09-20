resource "aws_lb" "tm_alb" {
  name               = "tm-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.tm_ecs_sg.id]
  subnets            = [aws_subnet.tm_public_subnet_1.id, aws_subnet.tm_public_subnet_2.id]

  enable_deletion_protection = false

  tags = {
    Name = "tm-alb"
  }
}

resource "aws_lb_target_group" "tm_target_group" {
  name        = "tm-target-group"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.tm_vpc.id
  target_type = "ip"

}

resource "aws_lb_listener" "tm_http" {
  load_balancer_arn = aws_lb.tm_alb.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type = "redirect"
  
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "tm_https" {
  load_balancer_arn = aws_lb.tm_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:767398132018:certificate/f09d2fe3-f013-4e45-8458-fdbc292d06f1"

  default_action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.tm_target_group.arn
        weight = 1
      }
      stickiness {
        enabled  = false
        duration = 1
      }
    }
  }
}