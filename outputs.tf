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

output "infra_alb_arn" {
  value = "${aws_lb.infra_alb.arn}"
}

output "infra_alb_name" {
  value = "${aws_lb.infra_alb.name}"
}

output "infra_alb_dns_name" {
  value = "${aws_lb.infra_alb.dns_name}"
}

output "infra_alb_zone_id" {
  value = "${aws_lb.infra_alb.zone_id}"
}

# try to return public resources, otherwise fall to empty
output "master_public_lb_arn" {
  value = "${coalesce(join(" ", aws_lb.master-alb.*.arn), join(" ", aws_elb.master-public.*.arn))}"
}

output "master_public_lb_name" {
  value = "${coalesce(join(" ", aws_lb.master-alb.*.name), join(" ", aws_elb.master-public.*.name))}"
}

output "master_public_lb_dns_name" {
  value = "${coalesce(join(" ", aws_lb.master-alb.*.dns_name), join(" ", aws_elb.master-public.*.dns_name))}"
}

output "master_public_lb_zone_id" {
  value = "${coalesce(join(" ", aws_lb.master-alb.*.zone_id), join(" ", aws_elb.master-public.*.zone_id))}"
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

output "deployment_node_private_ip" {
  value = "${aws_instance.deployment.*.private_ip}"
}
