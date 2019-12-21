class User < ActiveRecord::Base
    #has_secure_password
    has_many :students
    has_many :daycares, through: :students
end