require 'spigot/version'
require 'spigot/errors'
require 'spigot/patch'

# Parent module for Spigot
module Spigot
  autoload :ActiveRecord,  'spigot/active_record'
  autoload :Base,          'spigot/base'
  autoload :Configuration, 'spigot/configuration'
  autoload :Proxy,         'spigot/proxy'
  autoload :Record,        'spigot/record'
  autoload :Translator,    'spigot/translator'
  # Spigot mapping and definition classes
  module Map
    autoload :Base,        'spigot/map/base'
    autoload :Definition,  'spigot/map/definition'
    autoload :Option,      'spigot/map/option'
    autoload :Resource,    'spigot/map/resource'
    autoload :Service,     'spigot/map/service'
  end

  def self.define(&block)
    (config.map || Spigot::Map::Base.new).define(&block)
  end

  def self.service(name, &block)
    define do
      service(name, &block)
    end
  end

  def self.resource(name, &block)
    define do
      resource(name, &block)
    end
  end

  def self.configure
    yield config
  end

  def self.config
    Configuration.instance
  end

  # Support
  def self.root
    File.expand_path('../..', __FILE__)
  end

  def self.logger
    @log ||= Spigot.config.logger || begin
      buffer = Logger.new(STDOUT)
      if buffer
        buffer.level = ($PROGRAM_NAME == 'irb' ? Logger::DEBUG : Logger::INFO)
        buffer.formatter = proc { |severity, datetime, progname, msg| "#{msg}\n" }
      end
      buffer
    end
  end
end
