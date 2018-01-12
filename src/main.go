package main

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ecs"
	"github.com/google/go-github/github"
	"net/http"
	"os"
	"strings"
)

func main() {
	// Define the session so it can be reused.
	sess := session.Must(session.NewSession())
	clusters := list_clusters(sess)
	latest_ecs_version := get_latest_ecs_version()

	cluster_instances := outdated_agents_on_instance(clusters, sess, latest_ecs_version)
	http_response := execute(cluster_instances)
	fmt.Println(http_response)
}

func execute(cluster_instances map[string][]string) []string {
	var message_body string
	var slack_http_statuses []string
	for key, value := range cluster_instances {
		string_message := fmt.Sprintf("*Cluster:* %s\nhas *%d* instance(s) with outdated ecs agent.", key, len(value))
		message_body = send_to_slack(string_message)
		slack_http_statuses = append(slack_http_statuses, message_body)

	}
	return slack_http_statuses
}

func outdated_agents_on_instance(clusters []*string, sess *session.Session, latest_ecs_version string) map[string][]string {

	var instances_with_outdated_ecs []string
	var map_cluster_instances map[string][]string
	// Initialize the map
	map_cluster_instances = make(map[string][]string)

	// List the clusters and their instances.
	for _, cluster := range clusters {
		// Re-initialize the slice so that it only contains the instances from the current cluster that we are iterating on.
		instances_with_outdated_ecs = make([]string, 0)

		cluster_instances := describe_clusters(*cluster, sess)
		for _, instance := range cluster_instances {
			ecs_agent_version_in_instance := get_ecs_agent_on_instance(*instance, sess, *cluster)
			// If the ecs agent versions differ add them to the map.
			if latest_ecs_version != ecs_agent_version_in_instance {

				instances_with_outdated_ecs = append(instances_with_outdated_ecs, *instance)
				map_cluster_instances[*cluster] = instances_with_outdated_ecs
			}
		}
	}
	return map_cluster_instances
}

func send_to_slack(message string) string {

	type SlackMessageSimple struct {
		Text   string `json:"text"`
		Mrkdwn bool   `json:"mrkdwn"`
	}

	m := SlackMessageSimple{message, true}
	b, marshal_err := json.Marshal(m)

	response, err := http.Post(os.Getenv("SLACK_WEBHOOK_ENDPOINT"), "Content-type: application/json", bytes.NewBuffer(b))

	if err != nil || marshal_err != nil {
		fmt.Println(err.Error())
	}
	defer response.Body.Close()

	return response.Status
}

func get_latest_ecs_version() string {

	ctx := context.Background()
	git_client := github.NewClient(nil)
	latest_release, _, err := git_client.Repositories.GetLatestRelease(ctx, "aws", "amazon-ecs-agent")

	if err != nil {
		fmt.Println(err.Error())
	}
	return strings.TrimPrefix(*latest_release.TagName, "v")
}

func get_ecs_agent_on_instance(instance_arn string, s *session.Session, cluster_name string) string {

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
		fmt.Println(err.Error())
	}
	return result.ContainerInstanceArns
}
