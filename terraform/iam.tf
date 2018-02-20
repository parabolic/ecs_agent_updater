resource "aws_iam_role_policy" "lambda_kms_policy" {
  name = "${local.environment}_${local.application_name}_lambda_policy"
  role = "${aws_iam_role.iam_for_lambda.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1443036478000",
      "Effect": "Allow",
      "Action": [
        "kms:decrypt"
      ],
      "Resource": [
        "${aws_kms_key.kms_for_lambda.arn}"
      ]
    },
    {
      "Sid": "AllowECSFromLamda",
      "Effect": "Allow",
      "Action": [
        "ecs:ListClusters",
        "ecs:UpdateContainerAgent",
        "ecs:DescribeClusters",
        "ecs:DescribeContainerInstances",
        "ecs:ListContainerInstances"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
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
