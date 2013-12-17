ActiveRecord::Base.establish_connection({
  :adapter => "sqlite3",
  :database => ':memory:'
})

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :active_users, :force => true do |t|
    t.integer :github_id
    t.string :name
    t.string :username
    t.string :token
  end

  create_table :posts, :force => true do |t|
    t.integer :active_user_id
    t.string  :title
    t.text    :body
    t.timestamps
  end
end
