import ecs
import ecr

# Step 1: Create an ECS Fargate cluster.
ecs.create_cluster("cluster")

# Step 2: Define the Networking for our service.

# Step 3: Build and publish a Docker image to a private ECR registry.

# Step 4: Create a Fargate service task that can scale out.

# Step 5: Export the Internet address for the service.


# create repository
ecr.create_repository("my-repo")
