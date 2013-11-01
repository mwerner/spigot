require 'singleton'

module Spigot
  class Configuration
    include Singleton

    attr_accessor :path, :translations, :options_key, :logger

    @@defaults = {
      path: 'config/spigot',
      translations: nil,
      options_key: 'spigot',
      logger: nil
    }

    def self.defaults
      @@defaults
    end

    def initialize
      @@defaults.each_pair{|k,v| self.send("#{k}=",v)}
    end
  end
end
