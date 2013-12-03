module Spigot
  module Map
    class Resource

      attr_reader :definitions

      def initialize(name, &block)
        @name = name.to_s.underscore.to_sym
        @definitions = []
        @options = Spigot::Map::Option.new
        self.instance_eval(&block) if block_given?
      end

      def append(definition)
        @definitions << definition
      end

      def options(&block)
        @options = Spigot::Map::Option.new(&block)
      end

      def to_hash
        resource = {}
        @definitions.each{|rule| resource.merge!(rule.to_hash) }
        {@name => resource}
      end

      # Spigot::Map::Resource.new(:user){ username :login }
      # Spigot::Map::Resource.new(:user){ username = :login }
      def method_missing(name, *args, &block)
        name = name.to_s.gsub('=','').to_sym
        Spigot::Map::Definition.define(self, name, *args, &block)
      end

    end
  end
end
