module Spigot
  module Mapping

    class Post

      def self.basic
        {'post' => base}
      end

      def self.namespaced
        {'wrapper/post' => base}
      end

      private

      def self.base
        {title: 'title', body: 'description'}
      end
    end

  end
end
