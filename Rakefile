require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubygems"
require "bundler/setup"

# Immediately sync all stdout so that tools like buildbot can
# immediately load in the output.
$stdout.sync = true
$stderr.sync = true

# Change to the directory of this file.
Dir.chdir(File.expand_path("../", __FILE__))

# This installs the tasks that help with gem creation and
# publishing.
Bundler::GemHelper.install_tasks

# Install the `spec` task so that we can run tests.
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = "--order defined"
end
# Default task is to run the unit tests
task :default => :spec
