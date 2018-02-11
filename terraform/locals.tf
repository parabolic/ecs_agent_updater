locals = {
  environment               = "${terraform.workspace}"
  application_name          = "ecs_agent_updater"
  application_name_alphanum = "${replace(local.application_name,"_","-")}"
  region                    = "eu-west-1"
}
