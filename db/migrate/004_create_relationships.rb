class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      t.string :relp
      t.timestamps null: false
      t.integer :user_id
      t.integer :student_id
    end 
  end
end
