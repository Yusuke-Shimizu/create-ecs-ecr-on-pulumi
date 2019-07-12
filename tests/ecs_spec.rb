# # encoding: utf-8

# Inspec test for recipe install-py-rb-go::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

# Check command
RSpec.shared_context 'check_command' do
	its('stderr') { should eq '' }
	its('exit_status') { should eq 0 }
end

# https://docs.aws.amazon.com/ja_jp/AmazonECR/latest/userguide/Registries.html#registry_auth
# login
control 'login' do
	title 'push test for ecr'
	
	describe command("`aws ecr get-login --region ap-northeast-1 --no-include-email`") do
		# include_context 'check_command'
		its('stdout') { should include ("Login Succeeded") }
	end
	
end
control 'pull' do
	describe command("docker pull hello-world:latest") do
		include_context 'check_command'
	end
	describe docker_image('hello-world:latest') do
		it { should exist }
		# its('repo') { should eq 'alpine' }
		its('tag') { should eq 'latest' }
	end
	
end
control 'remove' do
	# remove image
	describe command("docker rmi hello-world:latest") do
		include_context 'check_command'
		its('stdout') { should include ("Untagged") }
	end
	describe docker_image('hello-world:latest') do
		it { should_not exist }
	end
end

