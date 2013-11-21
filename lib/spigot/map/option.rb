module Spigot
  module Map
    class Option

      def initialize(&block)
        @conditions = []
        instance_eval(&block) if block_given?
      end

      def primary_key(key=nil)
        return @primary_key if key.nil?
        @primary_key = key
      end

      def foreign_key(key=nil)
        return @foreign_key if key.nil?
        @foreign_key = key
      end

      def conditions(attributes=nil)
        return @attributes if attributes.nil?
        @conditions = attributes
      end

    end
  end
end
