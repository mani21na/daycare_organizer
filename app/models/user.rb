class User < ActiveRecord::Base
    has_secure_password
    has_many :students
    has_many :daycares, through: :students
    has_many :timetables, through: :students

    #def students 
    #end 
end

#user = User.create 
#user.students 
#user.daycares
#user.timetables 