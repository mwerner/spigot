module Spigot
  class MissingServiceError  < StandardError; end
  class InvalidServiceError  < StandardError; end
  class MissingResourceError < StandardError; end
  class InvalidResourceError < StandardError; end
  class InvalidDataError     < StandardError; end
  class InvalidSchemaError   < StandardError; end
end
