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

      def parse(data)
        data.default_proc = proc{|h, k| h.key?(k.to_s) ? h[k.to_s] : nil} if data.is_a?(Hash)
        if @children.empty?
          value = @parse ? @parse.call(data[@name]) : data[@name]
          return { @value.to_sym => value }
        end

        if data[@name].is_a?(Array)
          set = []
          data[@name].each do |element|
            set << parse_children(element)
          end
          { @name.to_sym => set }
        else
          parse_children(data[@name])
        end
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

      private

      def parse_children(data)
        child_hash = {}
        @children.each do |child|
          child_hash.merge!(child.parse(data))
        end
        child_hash
      end
    end
  end
end
