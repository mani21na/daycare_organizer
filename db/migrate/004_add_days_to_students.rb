class AddDaysToStudents < ActiveRecord::Migration[5.2]
    def change
      add_column :students, :attd_mon, :boolean
      add_column :students, :attd_tue, :boolean
      add_column :students, :attd_wed, :boolean
      add_column :students, :attd_thu, :boolean
      add_column :students, :attd_fri, :boolean
    end
  end