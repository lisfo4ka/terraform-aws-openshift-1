//  Collect together all of the output variables needed to build to the final
//  inventory from the inventory template.
data "template_file" "inventory" {
  template = "${file("${path.module}/resources/inventory.template.cfg")}"

  vars {
    platform_internal_subdomain = "${var.platform_internal_subdomain}"
    master_default_subdomain    = "${var.internet_facing == "external" ? format("%s.%s", var.platform_name, var.platform_external_subdomain) : var.platform_internal_subdomain}"

    cluster_id = "${var.platform_name}"
    user_name  = "${var.user_name}"
  }
}

data "template_file" "ec2_ini" {
  template = "${file("${path.module}/resources/ec2.template.ini")}"

  vars {
    region                = "${var.region}"
    filtered_cluster_name = "${var.platform_name}"
  }
}

//  Create the inventory.
resource "local_file" "inventory" {
  content  = "${data.template_file.inventory.rendered}"
  filename = "${data.null_data_source.path-to-local-file-inventory.outputs.filename}"
}

resource "local_file" "ec2_ini" {
  content  = "${data.template_file.ec2_ini.rendered}"
  filename = "${data.null_data_source.path-to-local-file-ec2_ini.outputs.filename}"
}

// Avoid absolute filename path to be written to statefile
data "null_data_source" "path-to-local-file-inventory" {
  inputs {
    filename = "${substr("${path.cwd}/inventory.cfg", length(path.cwd) + 1, -1)}"
  }
}

data "null_data_source" "path-to-local-file-ec2_ini" {
  inputs {
    filename = "${substr("${path.cwd}/ec2.ini", length(path.cwd) + 1, -1)}"
  }
}
