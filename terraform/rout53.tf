data "aws_route53_zone" "lab_zone" {
  name = "lab.mohammedsayed.com"
}

resource "aws_route53_record" "tm_alias_record" {
  zone_id = data.aws_route53_zone.lab_zone.id  
  name    = "tm.lab.mohammedsayed.com"
  type    = "A"

  alias {
    name                   = aws_lb.tm_alb.dns_name  
    zone_id                = aws_lb.tm_alb.zone_id   
    evaluate_target_health = false
  }
}
