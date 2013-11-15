module Spigot
  class Proxy

    attr_reader :owner

    def initialize(model)
      @owner = model
    end

    def translator(service)
      Translator.new(service, owner)
    end

    def map(service)
      translator(service).mapping.reject{|k,v| k == 'spigot'}
    end

    def options(service)
      translator(service).mapping['spigot'] || {}
    end

  end
end
