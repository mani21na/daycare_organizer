class CreateTimetables < ActiveRecord::Migration[5.2]
    def change
        create_table :timetables do |t|
          t.string :date
          t.string :check_in
          t.string :check_out
          t.text :report
          t.boolean :absence, :deflaut => false
          t.integer :student_id
          t.timestamps null: false
        end
    end
end