require 'rake/testtask'
require 'rubygems'
require 'bundler/setup'

desc "Run all tests"
Rake::TestTask.new do |task|
  task.test_files = Dir['test/**/*_test.rb']
  task.verbose = true
end

task default: :test
