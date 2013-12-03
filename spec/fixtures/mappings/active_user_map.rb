module Spigot
  module Mapping
    class ActiveUser

      def self.stub
        template do
          login :username
          full_name :name
        end
      end

      def self.with_options
        template do
          login :username
          full_name :name
          options do
            primary_key :username
            foreign_key :login
          end
        end
      end

      def self.non_unique_keys
        template do
          login :username
          full_name :name
          auth_token :token
          options do
            primary_key :token
            foreign_key :auth_token
          end
        end
      end

      private

      def self.template(&block)
        Spigot.define do
          service :github do
            resource :active_user do
              self.instance_eval(&block)
            end
          end
        end
      end

      # def self.basic
      #   {'active_user' => base}
      # end

      # def self.non_unique_key
      #   {'active_user' => base.merge('auth_token' => 'token', 'spigot' => non_unique)}
      # end

      # def self.with_invalid_options
      #   {'active_user' => base.merge('spigot' => invalid_options)}
      # end

      # private

      # def self.base
      #   {'full_name' => 'name', 'login' => 'username'}
      # end

      # def self.options
      #   {'primary_key' => 'username', 'foreign_key' => 'login'}
      # end

      # def self.non_unique
      #   {'primary_key' => 'token', 'foreign_key' => 'auth_token'}
      # end

      # def self.invalid_options
      #   {'primary_key' => 'nosuchcolumn', 'foreign_key' => 'nosuchkey'}
      # end
    end
  end
end
