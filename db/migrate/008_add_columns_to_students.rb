class AddColumnsToStudents < ActiveRecord::Migration[5.2]
    def change
      add_column :students, :timetable_id, :integer
    end
  end