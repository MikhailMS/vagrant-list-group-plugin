begin
  require 'vagrant'
rescue LoadError
  raise 'list-group should be used from within vagrant.'
end

# Ensure that the gem is not trying to be used from within a vagrant release
# that will not have the ability to load the plugin
if Vagrant::VERSION < "1.1.0"
  raise <<-WARN
  The list-group plugin is only compatible with Vagrant 1.1+.
  WARN
end

module ListGroup
  class Plugin < Vagrant.plugin("2")
    name "list-group command"
    description <<-DESC
    This plugin is an extension for `vagrant status`, returning list of boxes split into groups by prefix
    DESC

    command "list-group" do
      require_relative "command"
      Command
    end
  end
end
