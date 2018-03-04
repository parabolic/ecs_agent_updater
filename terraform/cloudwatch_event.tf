resource "aws_cloudwatch_event_rule" "ecs_agent_updater" {
  name                = "${local.environment}_${local.application_name}"
  description         = "Run the ${local.application_name} periodically as specified in the schedule expression"
  schedule_expression = "${local.cloudwatch_schedule_expression}"
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule      = "${aws_cloudwatch_event_rule.ecs_agent_updater.name}"
  target_id = "TriggerLambda"
  arn       = "${aws_lambda_function.ecs_agent_updater.arn}"
}
