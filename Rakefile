require 'rspec/core/rake_task'
require 'rubocop/rake_task'

# Style tests
RuboCop::RakeTask.new(:ruby)

# Unit tests
RSpec::Core::RakeTask.new(:spec)

# Default
task default: %w(ruby spec)

task full: %w(ruby spec integration)
