class CreateStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.string :birth_date
      t.string :attendance_day
      t.boolean :check_allergy
      t.string :allergies
      t.string :admission_date
      t.text :information
      t.integer :user_id
      t.integer :daycare_id
      t.timestamps null: false
    end 
  end
end
