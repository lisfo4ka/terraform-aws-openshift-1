# for ebs pv provisioning, node instances must residence in all subnets.

locals {
  node_scaling_subnet_ids = "${split(",", var.compute_node_count < length(var.private_subnet_ids) ? join(",", slice(var.private_subnet_ids, 0, var.compute_node_count)) : join(",", var.private_subnet_ids))}"
}

output subnets {
  value = "${local.node_scaling_subnet_ids}"
}
