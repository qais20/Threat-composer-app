data "aws_route53_zone" "lab_zone" {
  name = "lab.qaisnavaei.com"
}

# Create a record for the ALB
resource "aws_route53_record" "tm_record" {
  zone_id = data.aws_route53_zone.lab_zone.id
  name    = var.a_record_name
  type    = "CNAME"
  ttl     = 300
  records = [var.alb_dns_name]
}

