class AddColumns < ActiveRecord::Migration[5.2]
    def change
        add_column :users, :admin_flag, :integer
        add_column :users, :del_flag, :integer
        add_column :students, :del_flag, :integer
        add_column :daycares, :del_flag, :integer
    end
end