output "alb_url" {
  description = "The URL of the Application Load Balancer"
  value       = aws_lb.app-lb.dns_name
}