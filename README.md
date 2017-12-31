# Slack notifier for outdated versions of ecs agent on AWS.

This is a projects that lets you check for outdated ecs agents in AWS with using lambda. Currently it only supports reporting to slack. I am using docker to build and run the binary with using alpine linux.

## TODO

- Set auto update of the agent.
- Introduce other methods of notification.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

In order to run this project you will only need to have docker and docker-compose installed. Make sure you have the latest versions on your machine ( the docker-compose config file has version 3 specified ). Head on to https://www.docker.com/community-edition#/download and https://docs.docker.com/compose/install/ to have docker and docker-compose installed.

### Installing

Before compiling and running the source code you need to set the environment variables that will enable the code to have access to the ecs clusters.
The example file `env_file.example` needs to be copied and the variables filled in with their respective values. After putting the variables inside, copy the file so that it has the name env_file:

```
cp env_file.example env_file
```

In order to compile and run the go binary you only need to execute docker-compose.

```
docker-compose up --build
```
Which will put the binary inside the ./bin folder which can be run on linux systems and can be used as an artiact for deployment.

Running the binary is as simple as doing:
```
./bin/ecs_agent_version_checker
```

## Deployment

TODO.

## Built With

* [golang](https://golang.org/) - The programming language used.
* [docker](https://www.docker.com/community-edition) - Docker CE.
* [docker-compose](https://docs.docker.com/compose/) - Used to run the application.

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

I use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/ecs_agent_version_checker/project/tags).

## Authors

* **Nikola Velkovski** - *Initial work* - [parabolic](https://github.com/parabolic)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments
