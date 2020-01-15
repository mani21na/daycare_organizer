class StudentsController < ApplicationController
    #Add new students
    get '/student/new' do
        redirect_if_not_logged_in 
        @error_message = params[:error]

        @user = current_user
        @daycares = Daycare.all
        erb :"/students/new_student"
    end

    post "/student" do
        redirect_if_not_logged_in 
        @error_message = params[:error]
        @user = current_user
        @error = false
        if params[:first_name] == "" || params[:last_name] == ""
            @user = current_user
            @daycares = Daycare.all
            @error = true
            @error_msg = "Input First Name and Last Name. Try Again"
            erb :"/students/new_student"
        elsif !!Student.find_by(first_name: params[:first_name].upcase) && Student.find_by(first_name: params[:first_name].upcase).user_id == @user.id
            @user = current_user
            @daycares = Daycare.all
            @error = true
            @error_msg = "This name is already registered."
            erb :"/students/new_student"#, locals: {message: "This name is already registered."}
        elsif params[:check_allergy] == "true" && params[:allergies] == ""
            @user = current_user
            @daycares = Daycare.all
            @error = true
            @error_msg = "Please, Fill Allergies"
            erb :"/students/new_student"#, locals: {message: "Please, Fill Allergies"}
        elsif params[:birth_date] == "" || params[:admission_date] == "" || params[:attendance_day] == ""
            @user = current_user
            @daycares = Daycare.all
            @error = true
            @error_msg = "You are missing information"
            erb :"/students/new_student"#, locals: {message: "You are missing information"}
        else
            @student = Student.create(:first_name => params[:first_name].upcase, 
                                    :last_name => params[:last_name].upcase, 
                                    :birth_date => params[:birth_date], 
                                    :attendance_day => params[:attendance_day], 
                                    :check_allergy => params[:check_allergy], 
                                    :allergies => params[:allergies],
                                    :admission_date => params[:admission_date],
                                    :information => params[:information],
                                    :user_id => @user.id,
                                    :daycare_id => params[:daycare_id])
            @user = current_user
            erb :'users/main'
        end
    end
end
