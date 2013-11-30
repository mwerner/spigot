module Spigot
  module Map
    class Resource

      def initialize(name, &block)
        @name = name
        @definitions = []
        self.instance_eval(&block) if block_given?
      end

      def spigot(&block)
        @options = Spigot::Map::Option.new(&block)
      end

      def to_hash
        return @to_hash if defined?(@to_hash)
        result = {}
        @definitions.each do |definition|
          key = definition.instance_variable_get(:@name)
          val = definition.instance_variable_get(:@value)
          result.merge!(key => val)
        end
        @to_hash = result
      end

      # Spigot::Map::Resource.new(:user){ username :login }
      # Spigot::Map::Resource.new(:user){ username = :login }
      def method_missing(name, *args, &block)
        name = name.to_s.gsub('=','').to_sym
        define(name, *args, &block)
      end

      private

      def define(name, value = nil, &block)
        @definitions << Spigot::Map::Definition.new(name, value, &block)
      end

    end
  end
end
