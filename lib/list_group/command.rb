module ListGroup
  class Command < Vagrant.plugin("2", :command)
    def execute
      @env.ui.info "Current machine states:\n"
      group_prefix = ""
      ListGroup::VirtualBox::List.all.each do |entry|
      	box_name = entry.split(" ")[0]                   # entry.split returns ['box name', 'status', 'provider']
	state    = entry.split(" ")[1] 
        provider = entry.split(" ")[2]
        if get_group_prefix(box_name).eql? group_prefix
          @env.ui.info ListGroup::VMInfo.new(box_name, state, provider).inspect 
        else
	  group_prefix = get_group_prefix(box_name)
	  @env.ui.info "======\n[-- #{group_prefix.upcase} boxes --]\n"
          @env.ui.info ListGroup::VMInfo.new(box_name, state, provider).inspect
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
