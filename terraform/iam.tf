data "template_file" "lambda_kms_policy" {
  template = "${file("${path.module}/policies/lambda_kms_policy.json")}"

  vars {
    kms_for_lambda_arn = "${aws_kms_key.kms_for_lambda.arn}"
  }
}

resource "aws_iam_role_policy" "lambda_kms_policy" {
  name   = "${local.environment}_${local.application_name}_lambda_policy"
  role   = "${aws_iam_role.iam_for_lambda.id}"
  policy = "${data.template_file.lambda_kms_policy.rendered}"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "${local.environment}_${local.application_name}_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
