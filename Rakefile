require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new :test do |t|
  t.libs = ['lib', 'spec']
  t.test_files = FileList['spec/**/*_spec.rb']
end

task :default do
  Rake::Task['test'].execute
end
