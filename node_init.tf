data "template_file" "node_init" {
  template = "${file("${path.module}/resources/origin-node-init.yml")}"

  vars {
    rhn_username            = "${var.rhn_username}"
    rhn_password            = "${var.rhn_password}"
    rh_subscription_pool_id = "${var.rh_subscription_pool_id}"
  }
}

# master uses nvme disk
data "template_file" "master_node_init" {
  template = "${file("${path.module}/resources/origin-master-node-init.yml")}"

  vars {
    rhn_username            = "${var.rhn_username}"
    rhn_password            = "${var.rhn_password}"
    rh_subscription_pool_id = "${var.rh_subscription_pool_id}"
  }
}
