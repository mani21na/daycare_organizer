class Student < ActiveRecord::Base 
    belongs_to :user
    belongs_to :daycare
    has_many :timetables
end