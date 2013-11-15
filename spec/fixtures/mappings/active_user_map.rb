module Spigot
  module Mapping

    class ActiveUser

      def self.basic
        {'activeuser' => base}
      end

      def self.with_options
        {'activeuser' => base.merge('spigot' => options)}
      end

      def self.with_invalid_options
        {'activeuser' => base.merge('spigot' => invalid_options)}
      end

      private

      def self.base
        {'name' => 'name', 'login' => 'username'}
      end

      def self.options
        {'primary_key' => 'username', 'foreign_key' => 'login'}
      end

      def self.invalid_options
        {'primary_key' => 'nosuchcolumn', 'foreign_key' => 'nosuchkey'}
      end
    end

  end
end
