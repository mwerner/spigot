module Spigot
  module Data
    class ActiveUser
      class << self
        def basic
          { full_name: 'Dean Martin', login: 'classyasfuck', auth_token: '123abc' }
        end

        def alt
          { full_name: 'Frank Sinatra', login: 'livetilidie', auth_token: '987zyx' }
        end
      end
    end
  end
end
