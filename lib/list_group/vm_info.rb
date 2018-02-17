require 'vagrant/util'

module ListGroup
  class VMInfo
    include Vagrant::Util

    attr_accessor :raw
    attr_accessor :uuid
    attr_accessor :name
    attr_accessor :guest_os
    attr_accessor :box_state
    
    attr_accessor :provider

    def initialize(name, state, provider)
      if state.eql?("not")
        self.name = name
        self.box_state = "#{state} created"
        self.provider = provider
        self.guest_os = "UNKNOWN"
      else
        self.raw = `VBoxManage showvminfo #{name}`
        self.box_state = state
        self.provider = provider
        process!
      end
    end


    # Public - Override inspect to display
    # vm attributes
    def inspect
      state_provider = "[#{box_state} #{provider}]"
      "#{name.ljust(35, ' ')} #{state_provider.ljust(35, ' ')} [VM OS <-- #{guest_os}]"
    end

    private

    # Private - Accept raw output from VBoxManage showvminfo command
    # and manipulate string into a useful form.
    #
    # Requires raw be defined on the instance
    #
    # Returns the processed object
    def process!
      lines = self.raw.split("\n")
      lines.each do |line|
        raw_key, value = line.split(/\:\s+/)

        if raw_key
          key = raw_key.downcase.gsub(/\s+/, '_')
          self.send("#{key}=", value) if self.respond_to?("#{key}=") && !self.send(key)
        end
      end
      self
    end
  end
end
