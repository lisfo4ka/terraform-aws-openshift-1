data "aws_iam_policy_document" "master" {
  count = "${var.create_iam_profiles ? 1 : 0}"

  statement {
    actions = [
      "ec2:*",
      "ec2:AttachVolume",
      "ssm:GetDocument",
      "ec2:DetachVolume",
      "elasticloadbalancing:*",
      "cloudfront:ListDistributions",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticbeanstalk:DescribeEnvironments",
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetBucketWebsite",
      "ec2:DescribeVpcs",
      "ec2:DescribeRegions",
      "sns:ListTopics",
      "sns:ListSubscriptionsByTopic",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:GetMetricStatistics",
    ]

    effect = "Allow"

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role" "master" {
  count              = "${var.create_iam_profiles ? 1 : 0}"
  name               = "${var.platform_name}-master-role"
  assume_role_policy = "${data.aws_iam_policy_document.ec2.json}"
}

resource "aws_iam_role_policy" "master" {
  count  = "${var.create_iam_profiles ? 1 : 0}"
  name   = "${var.platform_name}-master-policy"
  role   = "${aws_iam_role.master.id}"
  policy = "${data.aws_iam_policy_document.master.json}"
}

resource "aws_iam_instance_profile" "master" {
  count = "${var.create_iam_profiles ? 1 : 0}"
  name  = "${var.platform_name}-master-profile"
  role  = "${aws_iam_role.master.name}"
}
