class CreateAdminusers < ActiveRecord::Migration[5.2]
    def change
        create_table :adminusers do |t|
            t.string :user_name
            t.string :password_digest
            t.integer :daycare_id
            t.timestamps null: false
        end 
    end
end