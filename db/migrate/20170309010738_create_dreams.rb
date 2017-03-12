class CreateDreams < ActiveRecord::Migration[5.0]
  def change
    create_table :dreams do |t|
      t.string :title
      t.text :body
      t.timestamp :date_occurred
      t.belongs_to :user

      t.timestamps
    end
  end
end
