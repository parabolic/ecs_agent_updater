resource "aws_kms_key" "kms_for_lambda" {
  description             = "KMS key for the lambda function"
  deletion_window_in_days = 10
  is_enabled              = true
  enable_key_rotation     = true

  tags {
    Name        = "${local.environment}_${local.application_name}"
    environment = "${local.environment}"
    created_by  = "terraform"
  }
}

resource "aws_kms_alias" "kms_for_lambda" {
  name          = "alias/${local.environment}_${local.application_name}_key"
  target_key_id = "${aws_kms_key.kms_for_lambda.key_id}"
}
