module Spigot
  module Data
    class Post
      class << self
        def basic
          {'title' => 'Brief Article', 'body' => 'lorem ipsum'}
        end

        def alt
          {'title' => 'Regular Article', 'body' => 'dolor sit amet', 'author' => 'Dean Martin'}
        end
      end
    end
  end
end
