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

      def reset
        @services = []
      end

      def service(name)
        services.detect{|s| s.name.to_sym == name.to_sym }
      end

      def has_service?(name)
        services.map{|s| s.name.to_s.downcase.to_sym }.include?(name.to_sym)
      end

      def inspect
        hash = {}; @services.each do |service|
          hash.merge!(service.name.to_sym => service.resources.map{|r| r.instance_variable_get(:@name) })
        end

        "#<Spigot::Map::Base #{hash.to_s}"
      end

    end
  end
end
