class DaycaresController < ApplicationController
    #Daycare main page
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
            elsif !!Adminuser.find_by(:username => params[:username])
                @error = true
                @error_msg = "Try Another Username Again"
                erb :'daycares/new_daycare'
            else
                Daycare.create(:name => params[:name], 
                            :phone => params[:phone], 
                            :address => params[:address], 
                            :last_name => params[:last_name], 
                            :phone => params[:phone], 
                            :address => params[:address],
                            :relationship => params[:relationship],
                            :alternative_phone => params[:alternative_phone])
                session[:user_id] = @user.id
                erb :'users/main_user'
            end
        end
    end

    #Student List by daycare_id
    get '/daycare/student/:id' do
        redirect_if_not_logged_in
        @error = false

        if !admin_user?
            redirect to '/show'
        else
            @student_list = Student.all.find_all{ |s| s.daycare_id.to_s == params[:id] }
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
            
        end
    end

end