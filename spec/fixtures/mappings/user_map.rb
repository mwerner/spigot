module Spigot
  module Mapping

    class User
      def self.basic
        {'user' => base}
      end

      def self.with_options
        {'user' => base.merge('spigot' => options)}
      end

      def self.with_conditions
        {'user' => base.merge('spigot' => options.merge(conditions))}
      end

      private

      def self.base
        {'full_name' => 'name', 'login' => 'username'}
      end

      def self.options
        {'primary_key' => 'username', 'foreign_key' => 'login'}
      end

      def self.conditions
        {'conditions' => 'username, name'}
      end
    end

  end
end
