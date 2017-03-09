class AddUrlAndLocationToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :url, :string
    add_column :users, :location, :string
  end
end
