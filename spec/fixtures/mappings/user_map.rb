module Spigot
  module Mapping
    class User

      def self.define_basic_map
        Spigot.define do
          service :github do
            resource :user do
              full_name :name
              login     :username
            end
          end
        end
      end

      private

    #   def self.basic_hash
    #     {'user' => base}
    #   end

    #   def self.symbolized
    #     {user: {full_name: 'name', login: 'username'}}
    #   end

    #   def self.nested
    #     {'user' => base.merge('login' => {'email' => 'contact', 'user_name' => 'username'})}
    #   end

    #   def self.nested_twice
    #     {'user' => base.merge('login' => {
    #       'contact' => {'work_email' => 'email', 'user_name' => 'username'}
    #     })}
    #   end

    #   def self.array
    #     {'user' => base}
    #   end

    #   def self.nested_array
    #     {'user' => {'account' => 'name', 'count' => 'user_count', 'users' => base}}
    #   end

    #   def self.nested_account_members
    #     {'activeuser' => {'account_name' => 'name', 'url' => 'url', 'members' => {'login' => 'email', 'full_name' => 'name'}}}
    #   end

    #   def self.with_options
    #     {'user' => base.merge('spigot' => options)}
    #   end

    #   def self.with_conditions
    #     {'user' => base.merge('spigot' => options.merge(conditions))}
    #   end

    #   private

    #   def self.base
    #     {'full_name' => 'name', 'login' => 'username'}
    #   end

    #   def self.options
    #     {'primary_key' => 'username', 'foreign_key' => 'login'}
    #   end

    #   def self.conditions
    #     {'conditions' => 'username, name'}
    #   end
    end

  end
end
