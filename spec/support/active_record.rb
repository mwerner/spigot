class ActiveUser < ActiveRecord::Base
  include Spigot::Base
end

ActiveRecord::Base.establish_connection({
  :adapter => "sqlite3",
  :database => ':memory:'
})

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :active_users, :force => true do |t|
    t.string :name
  end
end
