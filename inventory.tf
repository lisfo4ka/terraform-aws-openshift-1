//  Collect together all of the output variables needed to build to the final
//  inventory from the inventory template.
data "template_file" "inventory" {
  template = "${file("${path.module}/resources/inventory.template.cfg")}"

  vars {
    platform_internal_subdomain       = "${var.platform_internal_subdomain}"
    master_default_internal_subdomain = "${var.platform_name}.${var.platform_internal_subdomain}"
    master_default_subdomain          = "${var.internet_facing == "external" ? format("%s.%s", var.platform_name, var.platform_external_subdomain) : format("%s.%s", var.platform_name, var.platform_internal_subdomain)}"

    efs_fsid   = "${aws_efs_file_system.persistent_volumes.id}"
    aws_region = "${var.region}"

    cluster_id                          = "${var.platform_name}"
    user_name                           = "${var.user_name}"
    openshift_major_version             = "${var.openshift_major_version}"
    openshift_registry_s3_bucket_name   = "${aws_s3_bucket.openshift_registry_storage.bucket}"
    openshift_registry_root_directory   = "${local.openshift_registry_root_directory}"
    openshift_master_identity_providers = "[{'name': 'htpasswd_auth', 'login': 'true', 'challenge': 'true', 'kind': 'HTPasswdPasswordIdentityProvider'${var.openshift_major_version != "3.9" ? "" : ", 'filename': '/etc/origin/master/htpasswd'"}}]"
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
