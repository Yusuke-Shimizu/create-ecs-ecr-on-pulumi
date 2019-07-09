import pulumi
from pulumi_aws import ecr

def create_repository(repo_name):
    # create repository
    repository = ecr.Repository(repo_name);
    pulumi.export('repository_name', repository.name)
