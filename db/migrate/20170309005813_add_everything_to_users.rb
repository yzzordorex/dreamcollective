class AddEverythingToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :username, :string
    add_column :users, :real_name, :string
    add_column :users, :profile, :text
  end
end
