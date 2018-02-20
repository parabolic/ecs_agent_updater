# This template uploads the lambda code to s3.

resource "aws_s3_bucket_object" "upload_zipped_function_to_s3" {
  key = "${local.binary_file_name}.zip"

  bucket = "${aws_s3_bucket.go_lambda_function.id}"
  source = "${local.binary_file_path}.zip"
  etag   = "${md5(file("${local.binary_file_path}.zip"))}"
}
