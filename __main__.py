import pulumi
from pulumi_aws import ecs
from pulumi_aws import ecr

# Step 1: Create an ECS Fargate cluster.
cluster = ecs.Cluster("cluster")
pulumi.export('cluster_name', cluster.name)

# Step 2: Define the Networking for our service.

# Step 3: Build and publish a Docker image to a private ECR registry.

# Step 4: Create a Fargate service task that can scale out.

# Step 5: Export the Internet address for the service.


# create repository
repository = ecr.Repository("my-repo2");
pulumi.export('repository_name', repository.name)
