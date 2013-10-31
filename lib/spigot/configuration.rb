require 'singleton'

module Spigot
  class Configuration
    include Singleton

    attr_accessor :path, :translations, :options_key

    @@defaults = {
      path: 'config/spigot',
      translations: nil,
      options_key: 'spigot'
    }

    def self.defaults
      @@defaults
    end

    def initialize
      @@defaults.each_pair{|k,v| self.send("#{k}=",v)}
    end
  end
end
