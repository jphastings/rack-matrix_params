require 'rake'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

task :default => :build
task :build => :test # Require a sucessful test to build
task :test => :spec

if !defined?(RSpec)
	puts "spec targets require RSpec"
else
	desc "Run all examples"
	RSpec::Core::RakeTask.new(:spec) do |t|
		t.pattern = 'spec/**/*_spec.rb'
	end
end