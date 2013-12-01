module Spigot
  module Map
    class Definition

      def initialize(name, args=nil, parent=nil, &block)
        @name = name
        @value = args
        @children = []
        self.instance_eval(&block) if block_given?
        @parse = block unless @children.any?
      end

      def self.define(resource, name, value=nil, &block)
        definition = new(name, value, &block)
        resource.append definition
        definition
      end

      def to_hash
        result = {}; value = nil
        if @children.any?
          value = {}
          @children.each{|child| value.merge!(child.to_hash) }
        else
          value = @value
        end

        result.merge!({@name => value})
      end

      # Spigot::Map::Definition.new(:user){ username :login }
      # Spigot::Map::Definition.new(:user){ username = :login }
      def method_missing(name, *args, &block)
        name = name.to_s.gsub('=','').to_sym
        @children << Spigot::Map::Definition.new(name, *args, &block)
      end

    end
  end
end
