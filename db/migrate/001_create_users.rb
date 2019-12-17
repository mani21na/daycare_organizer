class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login_id
      t.string :password
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.text :address
      t.string :alternative_phone
      t.timestamps null: false
    end 
  end
end
