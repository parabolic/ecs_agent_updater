package main

import (
	"bytes"
	"context"
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ecs"
	"github.com/google/go-github/github"
	"io/ioutil"
	"net/http"
	"os"
	"strings"
)

func main() {
	// Define the session so it can be reused the same session.
	sess := session.Must(session.NewSession())
	clusters := list_clusters(sess)
	for _, cluster := range clusters {
		cluster_instances := describe_clusters(*cluster, sess)
		for _, instance := range cluster_instances {
			ecs_agent_version_in_instance := check_ecs_agent(*instance, sess, *cluster)
			latest_ecs_version := latest_ecs_agent()
			if latest_ecs_version != ecs_agent_version_in_instance {
				message_for_slack := "{\"text\": \"*Cluster:* \n" + *cluster + "\n*Instance:*\n" + *instance + "\n*Has outdated ecs version.*\n" + ecs_agent_version_in_instance + "\n *The latest ecs version is:*\n" + latest_ecs_version + "\", \"mrkdwn\": true}"
				send_to_slack(message_for_slack)
			}
		}
	}
}

func send_to_slack(message string) string {
	request_body := []byte(message)
	response, err := http.Post(os.Getenv("SLACK_WEBHOOK_ENDPOINT"), "Content-type: application/json", bytes.NewBuffer(request_body))
	if err != nil {
		// Message from an error.
		fmt.Println(err.Error())
	}
	defer response.Body.Close()
	body, err := ioutil.ReadAll(response.Body)
	return string(body)
}

func latest_ecs_agent() string {
	ctx := context.Background()
	git_client := github.NewClient(nil)
	latest_release, _, err := git_client.Repositories.GetLatestRelease(ctx, "aws", "amazon-ecs-agent")
	if err != nil {
		// Message from an error.
		fmt.Println(err.Error())
	}
	return strings.TrimPrefix(*latest_release.TagName, "v")
}

func check_ecs_agent(instance_arn string, s *session.Session, cluster_name string) string {

	var agent_version_in_instance string

	svc := ecs.New(s)
	input := &ecs.DescribeContainerInstancesInput{
		Cluster: aws.String(cluster_name),
		ContainerInstances: []*string{
			aws.String(instance_arn),
		},
	}
	result, err := svc.DescribeContainerInstances(input)
	if err != nil {
		// Message from an error.
		fmt.Println(err.Error())
	}
	for _, instance := range result.ContainerInstances {
		agent_version_in_instance = *instance.VersionInfo.AgentVersion
	}

	return agent_version_in_instance
}
func list_clusters(s *session.Session) []*string {
	svc := ecs.New(s)
	input := &ecs.ListClustersInput{}
	result, err := svc.ListClusters(input)

	if err != nil {
		// Message from an error.
		fmt.Println(err.Error())
	}
	return result.ClusterArns
}
func describe_clusters(cluster_name string, s *session.Session) []*string {
	svc := ecs.New(s)
	input := &ecs.ListContainerInstancesInput{
		Cluster: aws.String(cluster_name),
	}
	result, err := svc.ListContainerInstances(input)
	if err != nil {
		// Message from an error.
		fmt.Println(err.Error())
	}
	return result.ContainerInstanceArns
}
