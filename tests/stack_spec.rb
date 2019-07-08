# # encoding: utf-8

# Inspec test for recipe install-py-rb-go::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

# Check command
RSpec.shared_context 'check_command' do
	its('stderr') { should eq '' }
	its('exit_status') { should eq 0 }
end

# check command
describe command("pulumi stack") do
	include_context 'check_command'
	its('stdout') { should include ("aws:ecr/repository:Repository") }
	its('stdout') { should include ("aws:ecs/cluster:Cluster") }
end
