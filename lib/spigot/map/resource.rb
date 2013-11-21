module Spigot
  module Map
    class Resource

      def initialize(name, &block)
        @name = name
        @definitions = []
        instance_eval(&block) if block_given?
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
