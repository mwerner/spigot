module Spigot
  module Mapping
    class ActiveUser
      def self.stub
        template do
          login :username
          full_name :name
        end
      end

      def self.twitter
        Spigot.service(:twitter) do
          resource :active_user do
            login :username
            full_name :name
          end
        end
      end

      def self.with_options
        template do
          login :username
          full_name :name
          options do
            primary_key :username
          end
        end
      end

      def self.invalid_primary_key
        template do
          login :username
          full_name :name
          options do
            primary_key :doesnotexist
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
          end
        end
      end

      private

      def self.template(&block)
        Spigot.define do
          service :github do
            resource :active_user do
              instance_eval(&block)
            end
          end
        end
      end
    end
  end
end
