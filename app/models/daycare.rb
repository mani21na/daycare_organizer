class Daycare < ActiveRecord::Base 
    has_many :students
    has_many :users, through: :students
    has_many :timetables, through: :students
end
