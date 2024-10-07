
data "aws_route53_zone" "lab_zone" {
  name = "lab.qaisnavaei.com"
}

# Create a record for the ALB
resource "aws_route53_record" "tm_record" {
  zone_id = data.aws_route53_zone.lab_zone.id
  name    = "tm.lab.qaisnavaei.com"
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.app-lb.dns_name]
}




# # Creating a SSL cert

# resource "aws_acm_certificate" "cert" {
#   domain_name       = "*.qaisnavaei.com"
#   validation_method = "DNS"

#   tags = {
#     Environment = "test"
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# # Fetching the Route 53 Zone ID for my domainn
# data "aws_route53_zone" "selected" {
#   name         = "qaisnavaei.com"
#   private_zone = false
# }

# # Creating Route 53 Record for DNS validation
# resource "aws_route53_record" "cert_validation" {
#   for_each = {
#     for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       type   = dvo.resource_record_type
#       record = dvo.resource_record_value
#     }
#   }

#   zone_id = data.aws_route53_zone.selected.zone_id
#   name    = each.value.name
#   type    = each.value.type
#   ttl     = 60
#   records = [each.value.record]
# }

# # Wait for validation to complete
# resource "aws_acm_certificate_validation" "cert" {
#   certificate_arn         = aws_acm_certificate.cert.arn
#   validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
# }
