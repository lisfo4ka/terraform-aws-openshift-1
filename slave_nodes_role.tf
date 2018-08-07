data "aws_iam_policy_document" "slave_node" {
  statement {
    actions   = [
      "ec2:*",
      "ec2:AttachVolume",
      "ssm:GetDocument",
      "ec2:DetachVolume",
      "elasticloadbalancing:*",
    ]

    effect    = "Allow"
    resources = [
      "*"]
  }
}

resource "aws_iam_role" "slave_node" {
  count              = "${var.create_iam_profiles ? 1 : 0}"
  name               = "${var.platform_name}-compute-node-role"
  assume_role_policy = "${data.aws_iam_policy_document.ec2.json}"
}

resource "aws_iam_role_policy" "slave_node" {
  count  = "${var.create_iam_profiles ? 1 : 0}"
  name   = "${var.platform_name}-compute-node-policy"
  role   = "${aws_iam_role.slave_node.id}"
  policy = "${data.aws_iam_policy_document.slave_node.json}"
}

resource "aws_iam_instance_profile" "slave_node" {
  count = "${var.create_iam_profiles ? 1 : 0}"
  name  = "${var.platform_name}-compute-profile"
  role  = "${aws_iam_role.slave_node.name}"
}
