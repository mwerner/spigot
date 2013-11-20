module Spigot
  class Service

    attr_reader :name
    attr_accessor :resources

    @@services = []

    def initialize(name)
      @name = name
      @resources = []
    end

    def self.services
      @@services
    end

    def self.service(name, &block)
      service = Service.new(name)
      service.instance_eval(&block)
      @@services << service
    end

    def resource(name, &block)
      resources << Spigot::Resource.new(name, &block)
    end

  end
end
