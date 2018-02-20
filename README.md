# Updater for outdated ecs agent on AWS.

[![Build Status](https://travis-ci.org/parabolic/ecs_agent_version_checker.svg?branch=master)](https://travis-ci.org/parabolic/ecs_agent_version_checker)

---
**When using ECS on Amazon Web Services, the ecs agent on the instances is bound to get outdated at some point. Updating it can be automated and this is one implementation for that, using golang and lambda along with a cloudwatch scheduler which runs at a predefined cron like schedule. The code, scans all the clusters and it's instances and tries to update the ecs agent. If the agent is running on a OS that is not Amazon ECS-Optimized Linux, the update operation will fail and the error will be handled and reported to stdout.
Currently this code only supports reporting to slack.
Docker is used to build and zip the binary using alpine linux.**
---

### TODO

- Introduce other methods of notification.

### Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project to AWS.

### Prerequisites

In order to run this project you will need to have docker, docker-compose and terraform installed. Make sure you have the latest versions on your machine ( the docker-compose config file has version 3 specified ). Head on to https://www.docker.com/community-edition#/download and https://docs.docker.com/compose/install/ to have docker and docker-compose installed and https://www.terraform.io/downloads.html for installing terraform.

### Installing

Here are all env variables that need to be set in the run environment (in this case docker compose):

```sh
BINARY_FILE_NAME=main
```

The env variable UPDATE_ECS_AGENT should be set to `true` if you would like to update the ecs agents. You can find out more about updating the ecs agent here https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_UpdateContainerAgent.html.
The example file `env_file.example` needs to be copied and the variables filled in with their respective values. After putting the variables inside, copy the file so that it has the name env_file:

```
cp env_file.example env_file
```

In order to compile binary and generate the zip you will need to execute:

```
docker-compose up --build
```
Which will put the binary and the zipped binary nside the ./bin folder and it will be used as an artifact for deployment to AWS lambda.

## Deployment

Deployment is done on AWS using terraform. I will be using the dev terraform workspace for this example.
Before deploying, the lambda secrets need to be set as environment variables so that terraform can run successfully. Setting terraform env variables is done like this:


```
export TF_VAR_slack_webhook_endpoint=slack_secret
export TF_VAR_update_ecs_agent=true
```

Make sure that the zip is generated beforehand by running `docker-compose up --build` ( see the Istalling step )
If the dev workspace is not present go inside the teraform directory and create the desired workspace with the following command.

```
terraform workspace new dev
```

In order to deploy to aws make sure your AWS API credentials are configured properly and the terraform binary is in $PATH. Deploying to AWS is done with the following command executed at the root of this project.

```
./terraform_deploy.sh dev
```

After this you should see the lambda function deployed to AWS.

Removing the infrastructure can be easily done with:

```
cd terraform
terraform destroy
```

## Built With

* [golang](https://golang.org/) - The programming language used.
* [docker](https://www.docker.com/community-edition) - Docker CE.
* [docker-compose](https://docs.docker.com/compose/) - Used to run the application.
* [terraform](terraform.io) - Used for deploying the binary.

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

I use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/ecs_agent_version_checker/project/tags).

## Authors

* **Nikola Velkovski** - *Initial work* - [parabolic](https://github.com/parabolic)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments
