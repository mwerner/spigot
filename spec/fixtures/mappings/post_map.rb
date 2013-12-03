module Spigot
  module Mapping
    class Post


      def self.basic

        Spigot.define do
          service :github do
            resource 'wrapper/post' do
              title :title
              body :description
            end
          end
        end

      end


    end
  end
end
