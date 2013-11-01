module Spigot
  module Mapping
    def self.multiple_resources
      User.basic.merge(Post.basic)
    end
  end
end
