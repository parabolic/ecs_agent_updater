resource "aws_cloudwatch_event_rule" "ecs_agent_updater" {
  name                = "${local.environment}_${local.application_name}"
  description         = "Run the ${local.application_name} every monday at 11 am UTC"
  schedule_expression = "cron(0 11 ? * MON *)"
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule      = "${aws_cloudwatch_event_rule.ecs_agent_updater.name}"
  target_id = "TriggerLambda"
  arn       = "${aws_lambda_function.ecs_agent_updater.arn}"
}
