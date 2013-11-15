require "spigot/version"
require "spigot/errors"

module Spigot
  autoload :Configuration, 'spigot/configuration'
  autoload :Translator,    'spigot/translator'
  autoload :Record,        'spigot/record'
  autoload :Base,          'spigot/base'
  autoload :ActiveRecord,  'spigot/active_record'
  autoload :Proxy,         'spigot/proxy'

  def self.config
    Configuration.instance
  end

  def self.configure
    yield config
  end

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
