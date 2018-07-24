output "infra_lb_arn" {
  value = "${aws_elb.infra.arn}"
}

output "infra_lb_name" {
  value = "${aws_elb.infra.name}"
}

output "infra_lb_dns_name" {
  value = "${aws_elb.infra.dns_name}"
}

output "infra_lb_zone_id" {
  value = "${aws_elb.infra.zone_id}"
}

# try to return public resources, otherwise fall to empty
output "master_public_lb_arn" {
  value = "${coalesce(join(" ", aws_elb.master-public.*.arn), "")}"
}

output "master_public_lb_name" {
  value = "${coalesce(join(" ", aws_elb.master-public.*.name), "")}"
}

output "master_public_lb_dns_name" {
  value = "${coalesce(join(" ", aws_elb.master-public.*.dns_name), "")}"
}

output "master_public_lb_zone_id" {
  value = "${coalesce(join(" ", aws_elb.master-public.*.zone_id), "")}"
}

output "master_private_lb_name" {
  value = "${aws_elb.master.name}"
}

output "master_private_lb_dns_name" {
  value = "${aws_elb.master.dns_name}"
}

output "master_private_lb_zone_id" {
  value = "${aws_elb.master.zone_id}"
}

output "master_private_dns_name" {
  value = "master.${var.platform_name}"
}

output "platform_private_key" {
  sensitive = true
  value     = "${data.tls_public_key.platform.private_key_pem}"
}
