#-------------------------------------------------------------------------------
# Create some DNS records.
#-------------------------------------------------------------------------------
resource "aws_route53_record" "master_private_A" {
  zone_id = var.private_zone_id
  name    = "ipa.${var.domain}"
  type    = "A"
  ttl     = 86400
  records = [
    aws_instance.ipa_master.private_ip,
  ]
}

resource "aws_route53_record" "ca_private_A" {
  zone_id = var.private_zone_id
  name    = "ipa-ca.${var.domain}"
  type    = "A"
  ttl     = 86400
  records = [
    aws_instance.ipa_master.private_ip,
  ]
}

resource "aws_route53_record" "master_private_SRV" {
  count = length(local.tcp_and_udp)

  zone_id = var.private_zone_id
  name    = "_kerberos-master._${local.tcp_and_udp[count.index]}.${var.domain}"
  type    = "SRV"
  ttl     = 86400
  records = [
    "0 100 88 ipa.${var.domain}",
  ]
}

resource "aws_route53_record" "server_private_SRV" {
  count = length(local.tcp_and_udp)

  zone_id = var.private_zone_id
  name    = "_kerberos._${local.tcp_and_udp[count.index]}.${var.domain}"
  type    = "SRV"
  ttl     = 86400
  records = [
    "0 100 88 ipa.${var.domain}",
  ]
}

resource "aws_route53_record" "kerberos_private_TXT" {
  zone_id = var.private_zone_id
  name    = "_kerberos.${var.domain}"
  type    = "TXT"
  ttl     = 86400
  records = [
    upper(var.domain),
  ]
}

resource "aws_route53_record" "password_private_SRV" {
  count = length(local.tcp_and_udp)

  zone_id = var.private_zone_id
  name    = "_kpasswd._${local.tcp_and_udp[count.index]}.${var.domain}"
  type    = "SRV"
  ttl     = 86400
  records = [
    "0 100 464 ipa.${var.domain}",
  ]
}

resource "aws_route53_record" "ldap_private_SRV" {
  zone_id = var.private_zone_id
  name    = "_ldap._tcp.${var.domain}"
  type    = "SRV"
  ttl     = 86400
  records = [
    "0 100 389 ipa.${var.domain}",
  ]
}