require 'rake/testtask'

# Tasks
namespace :foreman_upman do
  namespace :example do
    desc 'Example Task'
    task task: :environment do
      # Task goes here
    end
  end
end

# Tests
namespace :test do
  desc 'Test ForemanUpman'
  Rake::TestTask.new(:foreman_upman) do |t|
    test_dir = File.join(File.dirname(__FILE__), '../..', 'test')
    t.libs << ['test', test_dir]
    t.pattern = "#{test_dir}/**/*_test.rb"
    t.verbose = true
    t.warning = false
  end
end

namespace :foreman_upman do
  task :rubocop do
    begin
      require 'rubocop/rake_task'
      RuboCop::RakeTask.new(:rubocop_foreman_upman) do |task|
        task.patterns = ["#{ForemanUpman::Engine.root}/app/**/*.rb",
                         "#{ForemanUpman::Engine.root}/lib/**/*.rb",
                         "#{ForemanUpman::Engine.root}/test/**/*.rb"]
      end
    rescue StandardError
      puts 'Rubocop not loaded.'
    end

    Rake::Task['rubocop_foreman_upman'].invoke
  end
end

Rake::Task[:test].enhance ['test:foreman_upman']

load 'tasks/jenkins.rake'
if Rake::Task.task_defined?(:'jenkins:unit')
  Rake::Task['jenkins:unit'].enhance ['test:foreman_upman', 'foreman_upman:rubocop']
end
