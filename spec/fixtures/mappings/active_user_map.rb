module Spigot
  module Mapping

    class ActiveUser

      def self.basic
        {'activeuser' => base}
      end

      def self.with_options
        {'activeuser' => base.merge('spigot' => options)}
      end

      private

      def self.base
        {name: 'name', login: 'username'}
      end

      def self.options
        {'primary_key' => 'username', 'foreign_key' => 'login'}
      end
    end

  end
end
