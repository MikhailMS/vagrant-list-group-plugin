require 'optparse'

module ListGroup
  class Command < Vagrant.plugin("2", :command)
    def self.synopsis
      "extends status command, outputs vagrant machines in groups and alphabetical order"
    end

    def execute
      opts = OptionParser.new do |o|
        o.banner = "Usage: vagrant list-group"
      end

      # Parse the options
      argv = parse_options(opts)
      return if !argv

      @env.ui.info "Defined box groups and box states:"
      
      # Identify longest name to ensure consist output
      max_name_length = 30
      with_target_vms(argv) do |machine|
        max_name_length = machine.name.length if machine.name.length > max_name_length
      end
      
      # Build hash of machines, to sort by name
      # machines = nil
      # with_target_vms(argv) do |machine|
      #   machines[:machine.name] = machine
      # end

      # machines.sort.to_h
      # group_prefix = ""
      # machine.name                     --> name of the VM,  ie test-machine
      # machine.box.name                 --> guest OS,        ie Centos-7.2
      # machine.state.short_description  --> state of the VM, ie running 
      # with_target_vms(argv) do |machine|
      #   box_name = machine.name.to_s      
      #   if get_group_prefix(box_name).eql? group_prefix
      #     @env.ui.info ListGroup::VMInfo.new(box_name, machine.state.short_description, machine.provider_name, machine.box.name, max_name_length).inspect 
      #   else
      #     group_prefix = get_group_prefix(box_name)
      #     @env.ui.info "\n======\n[-- #{group_prefix.upcase} boxes --]"
      #     @env.ui.info ListGroup::VMInfo.new(box_name, machine.state.short_description, machine.provider_name, machine.box.name, max_name_length).inspect
      #   end
      # end

      group_prefix = ""
      # machine.name                     --> name of the VM,  ie test-machine
      # machine.box.name                 --> guest OS,        ie Centos-7.2
      # machine.state.short_description  --> state of the VM, ie running 
      with_target_vms(argv) do |machine|
        box_name = machine.name.to_s      
        if get_group_prefix(box_name).eql? group_prefix
          @env.ui.info ListGroup::VMInfo.new(box_name, machine.state.short_description, machine.provider_name, machine.box.name, max_name_length).inspect 
        else
          group_prefix = get_group_prefix(box_name)
          @env.ui.info "\n======\n[-- #{group_prefix.upcase} boxes --]"
          @env.ui.info ListGroup::VMInfo.new(box_name, machine.state.short_description, machine.provider_name, machine.box.name, max_name_length).inspect
        end
      end
    end

    private

    def get_group_prefix(name)
      if name.include?("-")
        return name.split("-")[0]
      elsif name.include?("_")
        return name.split("_")[0]
      else
        raise ListGroup::CommandError, "In order to split boxes into groups, it box name should have '-' or '_' after group prefix, ie [prefix-name]" 
        return name.split(prefix_splitter)[0]
      end
    end
  end
end
