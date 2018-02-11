# This template zips and uploads the lambda code to s3.

data "archive_file" "zip_the_binary" {
  type        = "zip"
  source_file = "../bin/${local.application_name}"
  output_path = "../bin/${local.application_name}.zip"
}

resource "aws_s3_bucket_object" "upload_zipped_function_to_s3" {
  /* # Remove the "/tmp/" part of the string so when it gets uploaded to s3 it doesn't */  /* # go to a folder /tmp/ and instead goes to the base of the bucket */

  /* key = "${replace("${data.archive_file.lambda_function_cloudwatch_to_slack.output_path}", "/[[:punct:]]tmp[[:punct:]]/", "")}" */

  key = "${local.application_name}.zip"

  bucket     = "${aws_s3_bucket.go_lambda_function.id}"
  source     = "${data.archive_file.zip_the_binary.output_path}"
  etag       = "${md5(file("${data.archive_file.zip_the_binary.output_path}"))}"
  depends_on = ["data.archive_file.zip_the_binary"]
}
