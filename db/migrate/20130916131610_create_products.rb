class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.integer :user_id
      t.boolean :on_stock

      t.timestamps
    end
  end
end
