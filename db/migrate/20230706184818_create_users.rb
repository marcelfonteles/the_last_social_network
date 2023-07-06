class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.date :birthday
      t.integer :gender
      t.decimal :last_latitude, precision: 15, scale: 10
      t.decimal :last_longitude, precision: 15, scale: 10

      t.timestamps
    end
  end
end
