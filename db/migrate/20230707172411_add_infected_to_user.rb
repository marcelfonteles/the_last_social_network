class AddInfectedToUser < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :infected, :boolean, default: false, null: false
  end

  def down
    remove_column :users, :infected, :boolean
  end
end
