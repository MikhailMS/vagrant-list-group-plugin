module ListGroup
  class Command < Vagrant.plugin("2", :command)
    def self.synopsis
      "extends status command, outputs vagrant machines in groups and alphabetical order"
    end

    def execute
      @env.ui.info "Defined box groups and box states:"
      group_prefix = ""
      ListGroup::VirtualBox::List.all.each do |entry|
        if entry.split(" ").size==4
          box_name, state, _, provider = entry.split(" ")                   # entry.split returns ['box name', 'box status', 'box provider']
        else
          box_name, state, provider = entry.split(" ")
        end
        
        if get_group_prefix(box_name).eql? group_prefix
          @env.ui.info ListGroup::VMInfo.new(box_name, state, provider).inspect 
        else
          group_prefix = get_group_prefix(box_name)
          @env.ui.info "\n======\n[-- #{group_prefix.upcase} boxes --]"
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
