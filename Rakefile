require 'rspec/core/rake_task'
require 'rake'

# RSpec::Core::RakeTask.new('spec')
# task :default => :spec

namespace :pulumi do
    desc "setup pulumi"
        task :setup do
        sh 'virtualenv -p python3 venv'
        sh 'source venv/bin/activate'
        sh 'pip3 install -r requirements.txt'
    end
end

namespace :lint do
    desc "Check pulumi preview"
        task :pulumi do
        sh 'inspec exec tests/preview_spec.rb'
    end
end

namespace :build do
    desc "Build resources"
        task :pulumi do
        sh 'pulumi up --yes'
    end
end

namespace :test do
    namespace :unit do
        desc "Run awspec tests"
        namespace :awspec do
            RSpec::Core::RakeTask.new('spec')
            task :default => :spec
        end
        
        namespace :inspec do
            desc "Check pulumi stack"
                task :stack do
                sh 'inspec exec tests/stack_spec.rb'
            end
            # desc "Run first ansible Inspec tests"
            #     task :first do
            #     sh 'inspec exec spec/ansible_build_spec.rb'
            # end
            
            # desc "Run second ansible Inspec tests"
            #     task :second do
            #     sh 'inspec exec spec/ansible_second_build_spec.rb'
            # end
        end
        
        namespace :python do
            desc "unittest for ecr"
            task :ecr do
                sh 'python3 test_ecr.py'
            end
        end

    end
    namespace :integration do
        desc "ecs test"
            task :ecs do
            sh 'inspec exec tests/ecs_spec.rb'
        end
    end
end

namespace :destroy do
    desc "Destroy resources"
        task :pulumi do
        sh 'pulumi destroy --yes'
    end
end

namespace :ci do
  desc "Run CI test"
  task :default do
    Rake::Task["lint:pulumi"].invoke()
    Rake::Task["build:pulumi"].invoke()
    Rake::Task["test:unit:awspec:spec"].invoke()
    Rake::Task["test:unit:inspec:stack"].invoke()
    Rake::Task["destroy:pulumi"].invoke()
  end
end

