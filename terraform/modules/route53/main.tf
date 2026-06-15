# ── Public Hosted Zone ────────────────────────────────────────────────────────
resource "aws_route53_zone" "public" {
  name = var.domain_name

  tags = {
    Name        = var.domain_name
    Environment = var.environment
  }
}

# ── Private Hosted Zone ───────────────────────────────────────────────────────
resource "aws_route53_zone" "private" {
  count = var.create_private_zone ? 1 : 0

  name = "internal.${var.domain_name}"

  vpc {
    vpc_id = var.vpc_id
  }

  tags = {
    Name        = "internal.${var.domain_name}"
    Environment = var.environment
  }
}

# ── Health Check ──────────────────────────────────────────────────────────────
resource "aws_route53_health_check" "root" {
  fqdn              = var.domain_name
  port              = 443
  type              = "HTTPS"
  resource_path     = "/health"
  failure_threshold = 3
  request_interval  = 30

  tags = {
    Name = "${var.domain_name}-health-check"
  }
}

# ── CAA Record ────────────────────────────────────────────────────────────────
resource "aws_route53_record" "caa" {
  zone_id = aws_route53_zone.public.zone_id
  name    = var.domain_name
  type    = "CAA"
  ttl     = 300

  records = [
    "0 issue \"amazon.com\"",
    "0 issue \"letsencrypt.org\"",
  ]
}
