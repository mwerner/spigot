module Spigot
  module Map
    class Option
      def initialize(&block)
        @conditions = []
        instance_eval(&block) if block_given?
      end

      def primary_key(key = nil)
        return @primary_key if key.nil?
        @primary_key = key
      end
    end
  end
end
