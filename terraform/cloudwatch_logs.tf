resource "aws_cloudwatch_log_group" "lambda_function" {
  name = "${local.environment}-${local.application_name}"

  tags {
    Name        = "${local.environment}-${local.application_name}"
    environment = "${local.environment}"
    created_by  = "terraform"
  }
}
