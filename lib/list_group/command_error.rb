require 'vagrant/errors'

module ListGroup
  class CommandError < ::Vagrant::Errors::VagrantError
    error_key "command_failed"
  end
end
