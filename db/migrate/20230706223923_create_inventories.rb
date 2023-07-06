class CreateInventories < ActiveRecord::Migration[7.0]
  def change
    create_table :inventories do |t|
      t.references :user
      t.integer :item
      t.integer :quantity, default: 0

      t.timestamps
    end

    add_index :inventories, %i[user_id item], unique: true
  end
end
