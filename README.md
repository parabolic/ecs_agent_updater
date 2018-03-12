### Serverless, scheduled ecs agent updater.
When using AWS ECS, the ecs agent on the instances is bound to get outdated at some point. Updating it can be automated and this is one implementation for that. Serverless, using golang, lambda and cloudwatch events that trigger it on a cron like schedule. The code, scans all the ecs clusters and it's instances and updates the ecs agents. If the agent is running on a OS that is not Amazon ECS-Optimized Linux, the update operation will fail and the error will be handled and reported to stdout.

---

[![Build Status](https://travis-ci.org/parabolic/ecs_agent_updater.svg?branch=master)](https://travis-ci.org/parabolic/ecs_agent_updater)

<div align="center">
  <a href="https://golang.org/">
    <img src="https://raw.githubusercontent.com/parabolic/media/master/ecs_agent_updater/gopher_lambdaman.png"
      alt="lambdaman"
      width="400"
      height="400" />
  </a>
</div>

#### Getting Started
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy it to AWS.

#### Prerequisites
Having outdated ecs agents!

In order to run this project you will need to have docker, docker-compose and terraform installed. Make sure you have the latest versions on your machine (the docker-compose config file is using version 3).
All the applications can be installed from here:

- https://www.docker.com/community-edition#/download
- https://docs.docker.com/compose/install/
- https://www.terraform.io/downloads.html

Make sure your AWS API credentials are configured properly and the terraform binary is in $PATH.
More info about updating the ecs agent can be found here:

- https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_UpdateContainerAgent.html.


#### Installing
The env variables that need to be set in the build environment (in this case docker compose) are:

```sh
BINARY_FILE_NAME=main
```

The env variable UPDATE_ECS_AGENT should be set to `true` or `false` in the run environment. If it's set to true it will update the ecs agents .
The example file `env_file.example` needs to be copied and the variables filled in with their respective values. After putting the variables inside, copy the file so that it has the name `env_file`:

```
cp env_file.example env_file
```

To compile the binary and generate the zip you will need to execute:

```
docker-compose up --build
```

Which will put the binary and the zipped version inside the ./bin folder and will be used as an artifact for deploying to AWS lambda.


#### Deployment
Deployment is done using terraform. I will be using the dev terraform workspace for this example.
Before deploying, terraform secrets and other variables need to be set so that terraform can run successfully. Please note that the slack variable is optional whereas the update_ecs_agent is not.

```
export TF_VAR_slack_webhook_endpoint=slack_secret
export TF_VAR_update_ecs_agent=true
```

Make sure that the zip is generated beforehand by running `docker-compose up --build` ( see the installing step )
If the dev workspace is not present go inside the teraform directory and create the desired workspace with the following command.

```
terraform workspace new dev
```

Deploying to AWS is done with the following command executed at the root of this project.

```
./terraform_deploy.sh dev
```

After this you should see the lambda function deployed to AWS.

Removing the infrastructure can be easily done with:

```
cd terraform
terraform destroy
```

#### Built With
* [golang](https://golang.org/) - The programming language used.
* [docker](https://www.docker.com/community-edition) - Docker CE.
* [docker-compose](https://docs.docker.com/compose/) - Used for building the application.
* [terraform](terraform.io) - Used for deploying the binary.


#### Contributing
Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.


#### Versioning
I use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/ecs_agent_version_checker/project/tags).


#### Authors
* **Nikola Velkovski** - *Initial work* - [parabolic](https://github.com/parabolic)


#### License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details


#### Acknowledgments


#### TODO
Introduce other methods of notification.
