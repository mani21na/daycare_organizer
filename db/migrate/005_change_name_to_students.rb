class ChangeNameToStudents < ActiveRecord::Migration[5.2]
    def change
        rename_column :students, :attendance_day, :attd_option
    end
  end