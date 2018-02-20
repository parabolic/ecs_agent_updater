locals = {
  application_name          = "ecs_agent_updater"
  binary_file_name          = "main"
  binary_file_path          = "../bin/${local.binary_file_name}"
  region                    = "eu-west-1"
  environment               = "${terraform.workspace}"
  application_name_alphanum = "${replace(local.application_name,"_","-")}"
}
