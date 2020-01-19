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

        if !admin_user?
            redirect to '/show'
        else
            @student = Student.find(params[:id])
            @daycare = Daycare.find(@student.daycare_id)
            @parent = User.find(@student.user_id)
            erb :'daycares/info_student'
        end
    end

    #Daycare Admin Log-in
    get '/admin/show' do
        if !logged_in?
            redirect to '/admin'
        end

        @adminuser = current_user

        if admin_user?
            redirect to '/daycare/show'
        elsif daycare_admin_user?
            @student_list = Student.all.find_all{ |s| s.user_id.to_s == params[:id] && s.del_flag == 1}
            @daycare = Daycare.find(@student_list.first.daycare_id)
            erb :'daycares/admin_daycares/main_ad_dc'
        else
            redirect to '/daycare/show'
        end
    end
end