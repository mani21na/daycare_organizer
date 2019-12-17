class Daycare < ActiveRecord::Base 
    has_many :students
    has_many :relationships, through: :students
    has_namy :users, through: :relationships
end