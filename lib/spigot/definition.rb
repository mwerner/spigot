module Spigot
  class Definition

    def initialize(name, args, &block)
      @name = name
      @value = args
      @parse = block
    end

  end
end
