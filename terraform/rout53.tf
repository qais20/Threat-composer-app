data "aws_route53_zone" "lab_zone" {
  name = "lab.mohammedsayed.com"
}

resource "aws_route53_record" "tm_cname_record" {
  zone_id = data.aws_route53_zone.lab_zone.id  
  name    = "tm.lab.mohammedsayed.com"
  type    = "CNAME"
  
  ttl     = 300
  records = [aws_lb.tm_alb.dns_name] 
}