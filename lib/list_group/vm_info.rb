require 'vagrant/util'

module ListGroup
  class VMInfo
    include Vagrant::Util

    attr_accessor :name
    attr_accessor :box_state
    attr_accessor :provider    
    attr_accessor :guest_os

    attr_accessor :max_length

    def initialize(name, state, provider, guest_os, max_length)
      self.name       = name
      self.box_state  = state      
      self.provider   = provider
      self.guest_os   = guest_os
      self.max_length = max_length 
    end

    # Public - Override inspect to display
    # vm attributes
    def inspect
      state_provider = "[#{box_state} (#{provider})]"
      "#{name.ljust(max_length)} #{state_provider.ljust(max_length)} [VM OS <-- #{guest_os}]"
    end
  end
end
