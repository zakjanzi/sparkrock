variable "domain_name" {
  type        = string
  description = "FQDN for staging"
  default     = "sparkrock.zakjanzi.me"
}

# Request a public certificate (DNS validation)
resource "aws_acm_certificate" "app" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  tags              = local.tags

  lifecycle {
    create_before_destroy = true
  }
}

# Helpful outputs for creating DNS records later in Cloudflare
output "acm_certificate_arn" {
  value       = aws_acm_certificate.app.arn
  description = "Use this in ALB HTTPS listener"
}

# Map of DNS validation records to create (name -> value)
output "acm_dns_validation_records" {
  value = {
    for dvo in aws_acm_certificate.app.domain_validation_options :
    dvo.resource_record_name => dvo.resource_record_value
  }
  description = "Create CNAME(s): name => value (TTL ~300, DNS only - no proxy)"
}
