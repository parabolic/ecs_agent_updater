resource "aws_s3_bucket" "go_lambda_function" {
  bucket              = "${local.environment}-${local.application_name_alphanum}"
  acl                 = "private"
  acceleration_status = "Enabled"

  versioning {
    enabled = true
  }

  tags {
    Name        = "${local.environment}${local.application_name}"
    environment = "${local.environment}"
    created_by  = "terraform"
  }
}
