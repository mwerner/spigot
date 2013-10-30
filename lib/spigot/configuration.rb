require 'singleton'

module Spigot
  class Configuration
    include Singleton

    attr_accessor :path, :translations

    @@defaults = {
      path: 'config/spigot',
      translations: nil
    }

    def self.defaults
      @@defaults
    end

    def initialize
      @@defaults.each_pair{|k,v| self.send("#{k}=",v)}
    end
  end
end
