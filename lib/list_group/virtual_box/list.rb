module ListGroup
  module VirtualBox
    module List

      def self.all
        raw = `vagrant status`.split("\n")
        raise ListGroup::CommandError, "[vagrant status] returned non-zero status" if errored?

        process(raw)
      end

      def self.errored?
        $? != 0
      end

      private

      def self.process(raw)
        raw.map! do |line|
          next "" if line =~ /Current/i
          next "" if line =~ /VM/
          next line if true
        end.compact  
        raw -= [""]
        raw.sort
      end

    end
  end
end
