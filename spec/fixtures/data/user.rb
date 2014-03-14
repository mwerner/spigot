module Spigot
  module Data
    class User
      class << self
        def basic
          { 'id' => '123', 'full_name' => 'Dean Martin', 'login' => 'classyasfuck' }
        end

        def alt
          { 'full_name' => 'Frank Sinatra', 'login' => 'livetilidie', 'auth_token' => '456bcd' }
        end

        def full
          basic.merge('auth_token' => '123abc')
        end

        def array
          [full, alt]
        end

        def nested_array
          { 'account' => 'Rockafella', 'users' => array, 'count' => 2 }
        end

        def nested
          full.merge('login' => login_info)
        end

        def double_nested
          full.merge('login' => { 'contact' => login_info, 'last_seen_ip' => '127.0.0.1' })
        end

        private

        def login_info
          { 'email' => 'dino@amore.io', 'user_name' => 'classyasfuck' }
        end
      end
    end
  end
end
