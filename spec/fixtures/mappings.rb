module Spigot
  class Mapping
    def self.basic_user
      {'user' => {name: 'name', login: 'username'}}
    end

    def self.basic_post
      {'post' => {title: 'title', body: 'description'}}
    end

    def self.namespaced_post
      {'wrapper/post' => {title: 'title', body: 'description'}}
    end

    def self.multiple_resources
      basic_user.merge(basic_post)
    end
  end
end
