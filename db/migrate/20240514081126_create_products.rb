class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.float :price
      t.integer :stock
      t.references :seller, null: false, foreign_key: true
      t.string :image_url
      t.datetime :created_on

      t.timestamps
    end
  end
end
