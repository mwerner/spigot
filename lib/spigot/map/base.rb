module Spigot
  module Map
    class Base

      attr_reader :services

      def initialize(&block)
        @services = []
        if block_given?
          @services = Spigot::Map::Service.class_eval(&block) || []
        end
      end

      def update(&block)
        @services += (Spigot::Map::Service.class_eval(&block) || []) if block_given?
      end

      def has_service?(name)
        services.map{|s| s.name.to_s.downcase.to_sym }.include?(name.to_sym)
      end

    end
  end
end
