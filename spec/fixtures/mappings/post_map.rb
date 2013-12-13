module Spigot::Mapping::Post
  def self.basic
    Spigot.service(:github) do
      resource 'wrapper/post' do
        title :title
        body :description
      end
    end
  end
end
