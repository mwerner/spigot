module Spigot
  class Resource

    def initialize(name, &block)
      @name = name
      @definitions = []
      instance_eval(&block)
    end

    def define(name, value = nil, &block)
      @definitions << Definition.new(name, value, &block)
    end

    def method_missing(name, *args, &block)
      define(name, *args, &block)
    end

  end
end
