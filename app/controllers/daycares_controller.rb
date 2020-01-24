class DaycaresController < ApplicationController
    #Daycare main page for Admin User
    get '/daycare/show' do
        redirect_if_not_logged_in
        
        if !admin_user?
            redirect to '/show'
        else
            @daycare_list = Daycare.all
            erb :'daycares/main_admin'
        end
    end

    #Create New Daycare
    get '/daycare/new' do
        redirect_if_not_logged_in
        
        if !admin_user?
            redirect to '/show'
        else
            erb :'daycares/new_daycare'
        end
    end

    post '/daycare' do
        redirect_if_not_logged_in
        
        if !admin_user?
            redirect to '/show'
        else
            if params[:name] == "" || params[:phone] == "" || params[:address] == ""
                @error = true
                @error_msg = "Input Name and Telephon and Address. Try Again"
                erb :'daycares/new_daycare'
            elsif params[:username] == "" || params[:password] == ""
                @error = true
                @error_msg = "Input Username And Password. Try Again"
                erb :'daycares/new_daycare'
            elsif !!Daycare.find_by(:name => params[:name])
                @error = true
                @error_msg = "The name of daycare is already registered. Try another name."
                erb :'daycares/new_daycare'               
            elsif !!User.find_by(:username => params[:username])
                @error = true
                @error_msg = "Try Another Username Again"
                erb :'daycares/new_daycare'
            else
                @daycare = Daycare.create(
                    :name => params[:name], 
                    :phone => params[:phone], 
                    :address => params[:address], 
                    :information => params[:information], 
                    :announcement => params[:announcement]
                )
                @user = User.create(
                    :username => params[:username], 
                    :password => params[:password], 
                    :first_name => "DAYCARE",
                    :last_name => "ADMIN",
                    :admin_flag => 2
                )
                Student.create(
                    :first_name => "DAYCARE",
                    :last_name => "ADMIN",
                    :user_id => @user.id,
                    :daycare_id => @daycare.id,
                    :del_flag => 1
                )
                redirect to '/daycare/show'
            end
        end
    end

    #Edit Daycare
    get '/daycare/:id/edit' do
        redirect_if_not_logged_in

        if !admin_user?
            redirect to '/show'
        else
            @daycare = Daycare.find(params[:id].to_s)
            @adminstudent = Student.all.find_all{ |s| s.daycare_id.to_s == params[:id] && s.del_flag == 1}
            #@student = Student.where(daycare_id: params[:id].to_s, delete_flag: 1)
            @adminuser = User.find(@adminstudent.first.user_id.to_s)
            erb :'daycares/edit_daycare'
        end
    end

    patch '/daycare/:id' do
        redirect_if_not_logged_in
        
        if !admin_user?
            redirect to '/show'
        else
            @error = false

            @daycare = Daycare.find(params[:id])
            #@adminuser = User.find_all(:admin_flag => 2).detect{ |adminuser| adminuser.students.find_by(:daycare_id => @daycare.id)}
            @adminstudent = Student.all.find_all{ |s| s.daycare_id.to_s == params[:id] && s.del_flag == 1}
            @adminuser = User.find(@adminstudent.first.user_id)

            if params[:name] == "" || params[:phone] == "" || params[:address] == ""
                @error = true
                @error_msg = "Input Name and Telephon and Address. Try Again"
                erb :'daycares/edit_daycare'
            elsif params[:username] == "" || params[:password] == ""
                @error = true
                @error_msg = "Input Username And Password. Try Again"
                erb :'daycares/edit_daycare'
            elsif !!User.find_by(:username => params[:username]) && @adminuser.username != params[:username]
                @error = true
                @error_msg = "Try Another Username Again"
                erb :'daycares/edit_daycare'
            else
                @daycare.name = params[:name] if @daycare.name != params[:name]
                @daycare.phone = params[:phone] if @daycare.phone != params[:phone]
                @daycare.address = params[:address] if @daycare.address != params[:address]
                @daycare.information = params[:information] if @daycare.information != params[:information]
                @daycare.announcement = params[:announcement] if @daycare.announcement != params[:announcement]
                @daycare.save

                @adminuser.username = params[:username] if @adminuser.username != params[:username]
                @adminuser.password = params[:password] if @adminuser.password != params[:password]
                @adminuser.save

                @error = true
                @error_msg = "You successfully changed settings of #{@daycare.name} and #{@adminuser.username}"
                erb :'/daycares/edit_daycare'
            end
        end       
    end

    #Delete Daycare
    delete '/daycare/:id' do
        redirect_if_not_logged_in
        @error_message = params[:error]
        if !admin_user?
            redirect to '/show'
        elsif !@student_list = Student.all.find_all{ |s| s.daycare_id.to_s == params[:id] && s.del_flag == nil}.empty?
            @error = true
            @error_msg = "It is not able to DELETE this daycare due to student data belong to it."
            @daycare = Daycare.find(params[:id])
            @adminstudent = Student.all.find_all{ |s| s.daycare_id.to_s == params[:id] && s.del_flag == 1}
            @adminuser = User.find(@adminstudent.first.user_id)
            erb :'/daycares/edit_daycare'
        else
            Daycare.destroy(params[:id])
            @adminstudent_list = Student.all.find_all{ |s| s.daycare_id.to_s == params[:id] && s.del_flag == 1}
            @adminuser = User.find(@adminstudent_list.first.user_id)
            @adminuser.destroy
            @adminstudent_list.first.destroy

            redirect to '/daycare/show'
        end
    end

    #Student List by daycare_id
    get '/daycare/student/:id' do
        redirect_if_not_logged_in
        @error = false

        if !admin_user?
            redirect to '/show'
        else
            @student_list = Student.all.find_all{ |s| s.daycare_id.to_s == params[:id] && s.del_flag == nil}
            @daycare = Daycare.find(params[:id])

            if @student_list.empty?
                @error = true
                @error_msg = "This Daycare dosen't have students"
                erb :'daycares/list_student'
            else
                erb :'daycares/list_student'
            end
        end
    end

    #Student Information by student_id
    get '/daycare/:id/student' do
        redirect_if_not_logged_in

        if not_admin_user?
            redirect to '/show'
        else
            @student = Student.find(params[:id])
            @daycare = Daycare.find(@student.daycare_id)
            @parent = User.find(@student.user_id)
            erb :'daycares/info_student'
        end
    end

    #Daycare Admin: Log-in
    get '/admin/show' do
        if !logged_in?
            redirect to '/'
        end

        @adminuser = current_user
        @error = false
        if admin_user?
            redirect to '/daycare/show'
        elsif daycare_admin_user?
            @adminstudent_list = Student.all.find_all{ |s| s.user_id == @adminuser.id && s.del_flag == 1}
            @daycare = Daycare.find(@adminstudent_list.first.daycare_id.to_s)
            @student_list = Student.all.find_all{ |s| s.daycare_id == @daycare.id && s.del_flag != 1}

            if @student_list.empty?
                @error = true
                @error_msg = "This daycare dosen't have students"
                erb :'daycares/admin/main_ad_dc'
            else
                erb :'daycares/admin/main_ad_dc'
            end
        else
            redirect to '/show'
        end
    end

    #Daycare Admin: daycare edit
    get '/admin/daycare/:id/edit' do
        redirect_if_not_logged_in

        if !daycare_admin_user?
            redirect to '/show'
        else
            @daycare = Daycare.find(params[:id].to_s)
            @student_list = Student.all.find_all{ |s| s.daycare_id == @daycare.id && s.del_flag == nil}
            erb :'daycares/admin/edit_ad_dc'
        end
    end

    patch '/admin/:id' do
        redirect_if_not_logged_in
        
        if !daycare_admin_user?
            redirect to '/show'
        else
            @error = false

            @daycare = Daycare.find(params[:id])
            if params[:name] == "" || params[:phone] == "" || params[:address] == ""
                @error = true
                @error_msg = "Input Name and Telephon and Address. Try Again"
                erb :'daycares/edit_daycare'
            else
                @daycare.name = params[:name] if @daycare.name != params[:name]
                @daycare.phone = params[:phone] if @daycare.phone != params[:phone]
                @daycare.address = params[:address] if @daycare.address != params[:address]
                @daycare.information = params[:information] if @daycare.information != params[:information]
                @daycare.announcement = params[:announcement] if @daycare.announcement != params[:announcement]
                @daycare.save

                @error = true
                @error_msg = "You successfully changed settings of #{@daycare.name}."
                erb :'daycares/admin/edit_ad_dc'
            end
        end       
    end

    get '/daycares/most_popular' do
        binding.pry
        @daycare = Daycare.all.group_by{|daycare| daycare.students.count}.max.last

        @page_name = "The most popular daycare"
        erb :'daycares/info_daycare'
        #Most popular daycare. Daycare with the most students.      
        #Daycare has many students 
        #Some daycares have more students than others 
        #We want to find the daycare with the MOST students 
        #How do I find out how many students one daycare has?
        #daycare = Daycare.first
        #daycare.id => 1
        #daycare.students => [<Student>, <Student>, <Student>]
        #daycare.students.count => 3
        #daycare2 = Daycare.second 
        #daycare.students.count => 4       
    end 

    get '/daycares/least_popular' do
        @daycare = Daycare.all.group_by{ |daycare| daycare.students.count }.min.last
        @page_name = "The least popular daycare"
        erb :'daycares/info_daycare'
    end

end

# Write a custom route '/daycares/most_popular' that shows the user IN THE BROWSER the daycare with the most students 
#STEPS:
#In Daycare controller, write a get method to '/daycares/most_popular'
#In that method, we need to search database to find which daycare is the most popular 
#Then, send user to a new erb page that shows that daycare information 