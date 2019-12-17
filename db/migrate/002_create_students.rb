class CreateStudents < ActiveRecord::Migration
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
      t.timestamps null: false
    end 
  end
end
