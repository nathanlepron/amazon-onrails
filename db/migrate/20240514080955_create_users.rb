class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :address
      t.string :postal_code
      t.datetime :created_on

      t.timestamps
    end
  end
end
