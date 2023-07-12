class AddInfectedCountToUser < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :warning_count, :integer, default: 0, null: false
  end

  def down
    remove_column :users, :warning_count, :integer
  end
end
