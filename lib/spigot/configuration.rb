require 'singleton'

module Spigot
  class Configuration
    include Singleton

    attr_accessor :options_key, :logger, :map

    @@defaults = {
      options_key: 'options',
      logger: nil,
      map: nil
    }

    def self.defaults
      @@defaults
    end

    def initialize
      reset
    end

    def reset
      @@defaults.each_pair { |k, v| send("#{k}=", v) }
    end
  end
end
