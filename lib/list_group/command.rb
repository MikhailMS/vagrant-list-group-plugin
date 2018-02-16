module ListGroup
  class Command < Vagrant.plugin("2", :command)
    def execute
      @env.ui.info "Current machine states:\n"
      group_prefix = ""
      ListGroup::VirtualBox::List.all.each do |entry|
        box_name = entry.split(" ")[0]                   # entry.split returns ['box name', 'status', 'provider']
        provider = entry.split(" ")[2]
        if get_group_prefix(box_name).eql? group_prefix
          @env.ui.info Vagrant::List::VMInfo.new(box_name, provider).inspect 
        else
          @env.ui.info "\n======\n[-- #{group_prefix.upcase} boxes --]\n"
          @env.ui.info Vagrant::List::VMInfo.new(box_name, provider).inspect
        end
        group_prefix = get_group_prefix(box_name) 
      end
    end

    private

    def get_group_prefix(name)
      prefix_splitter = ""
      if name.include?("-")
        prefix_splitter = "-"
      elsif name.include("_")
        prefix_splitter = "_"
      else
        raise ListGroup::CommandError, "In order to split boxes into groups, it box name should have '-' or '_' after group prefix, ie [prefix-name]" 
      end
      return name.split(prefix_splitter)[0]
    end
  end
end
