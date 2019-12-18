require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'sinatra/activerecord/rake'
require_relative './config/environment'

task :default => :spec

RSpec::Core::RakeTask.new(:spec)

#ENV["SINATRA_ENV"] ||= "development"

desc 'Console for my application'
task :console do
    Pry.start
end
