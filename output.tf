output "platform_lb_arn" {
  value = "${aws_lb.platform_public.arn}"
}

output "master_lb_arn" {
  value = "${aws_lb.master.arn}"
}

output "master_lb_name" {
  value = "${aws_lb.master.name}"
}

output "master_private_dns_name" {
  value = "master.${var.platform_name}.internal"
}

output "platform_private_key" {
  sensitive = true
  value     = "${data.tls_public_key.platform.private_key_pem}"
}
