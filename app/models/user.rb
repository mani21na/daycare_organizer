class User < ActiveRecord::Base
    has_secure_password
    has_many :relationships
    has_many :students, through: :relationships
    has many :daycares, through: :students
end