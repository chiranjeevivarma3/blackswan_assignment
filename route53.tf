
# fetching data from aws account 
# chiranjeevi.xyz is godaddy domain provider added domain to my aws account
data "aws_route53_zone" "domain" {
  name         = "chiranjeevi.xyz"
  private_zone = false
}
# requesting for public certificate
resource "aws_acm_certificate" "democert" {
  domain_name       = "chiranjeevi.xyz"
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}
# validates and creates cname record in route53
resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.democert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
      wait_for_validation = true    
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.domain.id
  depends_on = [aws_acm_certificate.democert]
}
# cerficate validation
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.democert.arn
 
  validation_record_fqdns = [ for record in aws_route53_record.validation : record.fqdn]
}
# Standard route53 DNS record for  pointing to an ALB
resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.domain.id
  name    = "chiranjeevi.xyz"
  type    = "A"
  alias {
    name                   = aws_lb.demo.dns_name
    zone_id                = aws_lb.demo.zone_id
    evaluate_target_health = false
  }
}