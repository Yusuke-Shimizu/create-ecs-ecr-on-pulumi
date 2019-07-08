require 'spec_helper'
require 'json'

pulumi_stack = `pulumi stack output --json`
pulumi_hash = JSON.parse(pulumi_stack)
cluster_name = pulumi_hash["cluster_name"]

describe ecs_cluster(cluster_name) do
    it { should exist }
end
