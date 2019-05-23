data "aws_route53_zone" "wildcard_zone" {
  count        = "${var.internet_facing == "external" ? 1 : 0 }"
  name         = "${var.platform_external_subdomain}"
  private_zone = false
}

resource "aws_acm_certificate" "openshift-cluster" {
  count       = "${var.certificate_arn == "" && var.internet_facing == "external" ? 1 : 0 }"
  domain_name = "${var.platform_external_subdomain}"

  subject_alternative_names = [
    "*.${var.platform_name}.${var.platform_external_subdomain}",
    "${var.platform_name}.${var.platform_external_subdomain}",
  ]

  validation_method = "DNS"
}

resource "aws_route53_record" "openshift-cluster_cert-verification" {
  count   = "${var.certificate_arn == "" && var.internet_facing == "external" ? 3 : 0 }"
  name    = "${lookup(aws_acm_certificate.openshift-cluster.domain_validation_options[count.index], "resource_record_name")}"
  type    = "${lookup(aws_acm_certificate.openshift-cluster.domain_validation_options[count.index], "resource_record_type")}"
  zone_id = "${data.aws_route53_zone.wildcard_zone.zone_id}"
  records = ["${lookup(aws_acm_certificate.openshift-cluster.domain_validation_options[count.index], "resource_record_value")}"]
  ttl     = 300
}

resource "aws_acm_certificate_validation" "openshift-cluster" {
  count           = "${var.certificate_arn == "" && var.internet_facing == "external" ? 1 : 0 }"
  certificate_arn = "${aws_acm_certificate.openshift-cluster.arn}"

  validation_record_fqdns = [
    "${aws_route53_record.openshift-cluster_cert-verification.*.fqdn}",
  ]

  timeouts {
    create = "2h"
  }
}
