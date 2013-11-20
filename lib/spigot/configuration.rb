require 'singleton'

module Spigot
  class Configuration
    include Singleton

    attr_accessor :path, :translations, :options_key, :logger, :services

    @@defaults = {
      path: 'config/spigot',
      translations: nil,
      options_key: 'spigot',
      logger: nil,
      services: nil
    }

    def self.defaults
      @@defaults
    end

    def initialize
      reset
    end

    def reset
      @@defaults.each_pair{|k,v| self.send("#{k}=",v)}
    end
  end
end
