class Student < ActiveRecord::Base 
    has_many :relationships
    has_many :users, through: :relationships
    belongs_to :daycare
end