class CreateDaycares < ActiveRecord::Migration[5.2]
  def change
    create_table :daycares do |t|
      t.string :name
      t.string :phone
      t.text :address
      t.text :information
      t.text :announcement
      t.timestamps null: false
    end 
  end
end
