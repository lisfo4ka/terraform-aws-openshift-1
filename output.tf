output "infra_lb_arn" {
  value = "${aws_elb.infra.arn}"
}

output "infra_lb_name" {
  value = "${aws_elb.infra.name}"
}

output "master_lb_arn" {
  value = "${aws_elb.master.arn}"
}

output "master_lb_name" {
  value = "${aws_elb.master.name}"
}

output "master_private_dns_name" {
  value = "master.${var.platform_name}"
}

output "platform_private_key" {
  sensitive = true
  value     = "${data.tls_public_key.platform.private_key_pem}"
}
