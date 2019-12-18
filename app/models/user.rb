class User < ActiveRecord::Base
    #has_secure_password
    has_many :relationships
    has_many :students, through: :relationships
    has_many :daycares, through: :students
end