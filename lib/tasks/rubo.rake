# frozen_string_literal: true

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

RuboCop::RakeTask.new do |task|
  task.requires << 'rubocop-rails'
end
