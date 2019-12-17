class Relationship < ActiveRecord::Base 
    belongs to :user
    belongs to :student
end