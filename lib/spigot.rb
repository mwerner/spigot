require "spigot/version"

module Spigot
  autoload :Configuration, 'spigot/configuration'
  autoload :Translator,    'spigot/translator'
  autoload :Factory,       'spigot/factory'
  autoload :Base,          'spigot/base'
  autoload :ActiveRecord,  'spigot/active_record'

  class MissingServiceError  < StandardError; end
  class InvalidServiceError  < StandardError; end
  class MissingResourceError < StandardError; end
  class InvalidResourceError < StandardError; end
  class InvalidDataError     < StandardError; end

  def self.config
    Configuration.instance
  end

  def self.configure
    yield config
  end

  def self.root
    File.expand_path('../..', __FILE__)
  end
end
