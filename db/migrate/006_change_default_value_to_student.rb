class ChangeDefaultValueToStudent < ActiveRecord::Migration[5.2]
    def change
        change_column_default :students, :attd_mon, false
        change_column_default :students, :attd_tue, false
        change_column_default :students, :attd_wed, false
        change_column_default :students, :attd_thu, false
        change_column_default :students, :attd_fri, false
    end
end