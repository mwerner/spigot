require "spigot/version"
require "spigot/errors"
require "spigot/patch"

module Spigot
  autoload :ActiveRecord,  'spigot/active_record'
  autoload :Base,          'spigot/base'
  autoload :Configuration, 'spigot/configuration'
  autoload :Proxy,         'spigot/proxy'
  autoload :Record,        'spigot/record'
  autoload :Translator,    'spigot/translator'
  module Map
    autoload :Definition,    'spigot/map/definition'
    autoload :Resource,      'spigot/map/resource'
    autoload :Service,       'spigot/map/service'
  end

  ##=> Definition
  def self.define(&block)
    config.services = Spigot::Map::Service.class_eval(&block)
  end

  def self.services
    config.services.dup
  end

  ##=> Configuration
  def self.config
    Configuration.instance
  end

  def self.configure
    yield config
  end

  ##=> Support
  def self.root
    File.expand_path('../..', __FILE__)
  end

  def self.logger
    @log ||= Spigot.config.logger || begin
      buffer = Logger.new(STDOUT)
      buffer.level = $0 == 'irb' ? Logger::DEBUG : Logger::INFO
      buffer.formatter = proc{|severity, datetime, progname, msg| "#{msg}\n"}
      buffer
    end
  end
end
