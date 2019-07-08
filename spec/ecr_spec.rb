require 'spec_helper'
require 'json'

pulumi_stack = `pulumi stack output --json`
pulumi_hash = JSON.parse(pulumi_stack)
repository_name = pulumi_hash["repository_name"]

describe ecr_repository(repository_name) do
    it { should exist }
end
