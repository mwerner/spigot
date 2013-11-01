module Spigot
  module Mapping

    class User
      def self.basic
        {'user' => base}
      end

      def self.with_options
        {'user' => base.merge('spigot' => options)}
      end

      private

      def self.base
        {name: 'name', login: 'username'}
      end

      def self.options
        {'primary_key' => 'service_id', 'foreign_key' => 'remote_id'}
      end
    end

  end
end
