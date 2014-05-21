require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:default) do |task|
  task.profile = "default"
  task.cucumber_opts = ["--tags", "#{ENV["tags"]}"]
end