class Daycare < ActiveRecord::Base 
    has_many :students
    has_many :users, through: :students
end