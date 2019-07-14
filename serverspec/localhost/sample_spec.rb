require 'spec_helper'

# Check command
RSpec.shared_context 'check_command' do
	its('stderr') { should eq '' }
	its('exit_status') { should eq 0 }
end

def check_preview(resources)
	describe command("pulumi preview") do
		include_context 'check_command'
		resources.each{|resource_name|
			its('stdout') { should match (/aws:#{resource_name}.*create/) }
		}
	end
end

def check_up(resources)
	describe command("pulumi up --yes") do
		include_context 'check_command'
		resources.each{|resource_name|
			its('stdout') { should match (/\+.*aws:#{resource_name}.*created/) }
		}
	end
end

def check_destroy(resources)
	describe command("pulumi destroy --yes") do
		include_context 'check_command'
		resources.each{|resource_name|
			its('stdout') { should match (/\-.*aws:#{resource_name}.*deleted/) }
		}
	end
end

resources = ["ecr:Repository", "ecs:Cluster"]
check_preview(resources)
check_up(resources)

# TODO
# docker image ls --quiet
# のリストが前後で変わらないことをチェックする

# https://docs.aws.amazon.com/ja_jp/AmazonECR/latest/userguide/Registries.html#registry_auth
# login
describe command("`aws ecr get-login --region ap-northeast-1 --no-include-email`") do
	its('stdout') { should include ("Login Succeeded") }
end

# get image
local_image_name = "hello-world:latest"
describe command("docker pull #{local_image_name}") do
	include_context 'check_command'
end
describe docker_image(local_image_name) do
	it { should exist }
end

describe command("sleep 60") do
	include_context 'check_command'
end

# get repository info
pulumi_stack = `pulumi stack output --json`
pulumi_hash = JSON.parse(pulumi_stack)
repository_url = pulumi_hash["repository_url"]
# ecr_repository_name = pulumi_hash["repository_name"]

# add tag
ecr_image_name = "#{repository_url}:latest"
# ecr_image_name_and_tag = "#{ecr_image_name}:latest"
describe command("docker tag #{local_image_name} #{ecr_image_name}") do
	include_context 'check_command'
end
describe docker_image(ecr_image_name) do
	it { should exist }
end

# push image
describe command("docker push #{ecr_image_name}") do
	include_context 'check_command'
# 	its('stdout') { should include ("Pushed") }
end
describe command("docker pull #{ecr_image_name}") do
	include_context 'check_command'
# 	its('stdout') { should include ("pulled") }
end

# remove image
describe command("docker rmi #{ecr_image_name}") do
	include_context 'check_command'
	its('stdout') { should include ("Untagged") }
end
describe docker_image(ecr_image_name) do
	it { should_not exist }
end

# remove image
describe command("docker rmi #{local_image_name}") do
	include_context 'check_command'
	its('stdout') { should include ("Untagged") }
end
describe docker_image(local_image_name) do
	it { should_not exist }
end

check_destroy(resources)
