class Student < ActiveRecord::Base 
    belongs_to :user
    belongs_to :daycare
end