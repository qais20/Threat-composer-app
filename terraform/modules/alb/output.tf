output "alb_url" {
  description = "The URL of the Application Load Balancer"
  value       = aws_lb.app-lb.dns_name
}

output "alb_arn" {
  value = aws_lb.app-lb.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.tm-tg.arn
}

output "http_listener" {
  value = aws_lb_listener.tm_http.id
}

output "https_listener" {
  value = aws_lb_listener.tm_https.id
}

output "alb_dns_name" {
  value = aws_lb.app-lb.dns_name
}
