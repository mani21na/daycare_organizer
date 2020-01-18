class StudentsController < ApplicationController
    #Create new students
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
        @daycares = Daycare.all
        @error = false
        if params[:first_name] == "" || params[:last_name] == ""
            @error = true
            @error_msg = "Input First Name and Last Name. Try Again"
            erb :"/students/new_student"
        elsif !!Student.find_by(first_name: params[:first_name].upcase) && Student.find_by(first_name: params[:first_name].upcase).user_id == @user.id
            @error = true
            @error_msg = "This name is already registered."
            erb :"/students/new_student"#, locals: {message: "This name is already registered."}
        elsif params[:check_allergy] == "true" && params[:allergies] == ""
            @error = true
            @error_msg = "Please, Fill Allergies"
            erb :"/students/new_student"#, locals: {message: "Please, Fill Allergies"}
        elsif params[:birth_date] == "" || params[:admission_date] == "" || params[:attendance_day] == ""
            @error = true
            @error_msg = "You are missing information"
            erb :"/students/new_student"#, locals: {message: "You are missing information"}
        else
            @student = Student.create(:first_name => params[:first_name].upcase, 
                                    :last_name => params[:last_name].upcase, 
                                    :birth_date => params[:birth_date], 
                                    :attd_option => params[:attd_option],
                                    :attd_mon => params[:attd_mon],
                                    :attd_tue => params[:attd_tue],
                                    :attd_wed => params[:attd_wed],
                                    :attd_thu => params[:attd_thu],
                                    :attd_fri => params[:attd_fri],
                                    :check_allergy => params[:check_allergy], 
                                    :allergies => params[:allergies],
                                    :admission_date => params[:admission_date],
                                    :information => params[:information],
                                    :user_id => @user.id,
                                    :daycare_id => params[:daycare_id])
            
            redirect to '/show'
        end
    end

    #Edit student setting
    get '/student/:id/edit' do
        redirect_if_not_logged_in 
        @error_message = params[:error]

        @student = Student.find(params[:id])
        @daycares = Daycare.all

        erb :'/students/edit_student'
    end

    patch '/student/:id' do
        redirect_if_not_logged_in 
        @error_message = params[:error]

        @student = Student.find(params[:id])
        @daycares = Daycare.all
        @user = current_user

        @error = false
        if params[:first_name] == "" || params[:last_name] == ""
            @error = true
            @error_msg = "You missed First Name or Last Name"
            erb :'/students/edit_student'
        elsif !!Student.find_by(first_name: params[:first_name].upcase) && Student.find_by(first_name: params[:first_name].upcase).user_id == @user.id && @student.first_name != params[:first_name].upcase
            @error = true
            @error_msg = "The name that you input is already registered."
            erb :'/students/edit_student'#, locals: {message: "This name is already registered."}
        elsif params[:check_allergy] == "true" && params[:allergies] == ""
            @error = true
            @error_msg = "Please, Fill Allergies"
            erb :'/students/edit_student'#, locals: {message: "Please, Fill Allergies"}
        elsif params[:birth_date] == "" || params[:admission_date] == "" || params[:attendance_day] == ""
            @error = true
            @error_msg = "You are missing information"
            erb :'/students/edit_student'#, locals: {message: "You are missing information"}
        else
            @student.first_name = params[:first_name] if @student.first_name != params[:first_name]
            @student.last_name = params[:last_name] if @student.last_name != params[:last_name]
            @student.birth_date = params[:birth_date] if @student.birth_date != params[:birth_date]
            @student.daycare_id = params[:daycare_id] if @student.daycare_id != params[:daycare_id]
            @student.attd_option = params[:attd_option] if @student.attd_option != params[:attd_option]
            @student.attd_mon = params[:attd_mon] if @student.attd_mon != params[:attd_mon]
            @student.attd_tue = params[:attd_tue] if @student.attd_tue != params[:attd_tue]
            @student.attd_wed = params[:attd_wed] if @student.attd_wed != params[:attd_wed]
            @student.attd_thu = params[:attd_thu] if @student.attd_thu != params[:attd_thu]
            @student.attd_fri = params[:attd_fri] if @student.attd_fri != params[:attd_fri]
            @student.check_allergy = params[:check_allergy] if @student.check_allergy != params[:check_allergy]
            @student.allergies = params[:allergies] if @student.allergies != params[:allergies]
            @student.admission_date = params[:admission_date] if @student.admission_date != params[:admission_date]
            @student.information = params[:information] if @student.information != params[:information]
            @student.save

            @error = true
            @error_msg = "You successfully changed settings of #{@student.first_name} #{@student.last_name}"
            erb :'/students/edit_student'#, locals: {message: "You are missing information"}
        end
    end

    #Delet student
    delete "/student/:id" do
        redirect_if_not_logged_in 
        @error_message = params[:error]

        Student.destroy(params[:id])
        redirect to "/show"
    end
end
