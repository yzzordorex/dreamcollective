class AddTokenAndExpiresToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :token, :string
    add_column :users, :token_expires_at, :datetime
    add_column :users, :verified, :boolean, null: false, default: false
    add_column :users, :admin, :boolean, null: false, default: false
  end
end
