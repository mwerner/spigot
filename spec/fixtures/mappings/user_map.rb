module Spigot
  module Mapping
    class User

      def self.basic
        template do
          full_name :name
          login     :username
        end
      end

      def self.nested
        template do
          full_name :name
          login do
            email     :contact
            user_name :username
          end
        end
      end

      def self.nested_twice
        template do
          full_name :name
          login do
            last_seen_ip :ip
            contact do
              email     :contact
              user_name :username
            end
          end
        end
      end

      private

      def self.template(&block)
        Spigot.define do
          service :github do
            resource :user do
              self.instance_eval(&block)
            end
          end
        end
      end

    end
  end
end
