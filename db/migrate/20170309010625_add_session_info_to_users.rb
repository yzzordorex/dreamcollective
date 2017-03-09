class AddSessionInfoToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :last_login, :datetime
    add_column :users, :ip_address, :string
  end
end
