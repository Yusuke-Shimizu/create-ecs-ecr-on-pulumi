require 'spec_helper'

# Check command
RSpec.shared_context 'check_command' do
	its('stderr') { should eq '' }
	its('exit_status') { should eq 0 }
end

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

# docker tag hello-world:latest 889119567707.dkr.ecr.ap-northeast-1.amazonaws.com/my-repo-54cacda:latest
# docker push 889119567707.dkr.ecr.ap-northeast-1.amazonaws.com/my-repo-54cacda:latest
# docker push 889119567707.dkr.ecr.ap-northeast-1.amazonaws.com/my-repo-54cacda/my-repo-54cacda:latest
# docker pull 889119567707.dkr.ecr.ap-northeast-1.amazonaws.com/my-repo-54cacda:latest


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
