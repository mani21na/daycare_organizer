class TimetablesController < ApplicationController
    #Create timetable 
    get '/timetable/:id/new' do
        redirect_if_not_logged_in
        @error_message = params[:error]

        if admin_user?
            redirect to '/dyacare/show'
        else
            @user = current_user
            @student = Student.find(params[:id])
            @daycare = Daycare.find(@student.daycare_id.to_s)
            @timetable = @student.timetables.find_by(:date => Time.now.strftime("%m/%d/%Y"))
#=begin
            if student_attd_validate(@student) == false
                @error = true
                @error_msg = "The student that you click is not attendence today"
                erb :'users/main_user'
                #redirect to "/show"
            elsif !!@timetable
                #erb :"/daycares/timetables/edit_timetable"
                redirect to "/timetable/#{@timetable.id}/edit"
            else
                erb :"/students/timetables/new_timetable"
            end
#=end
=begin
        #for test, remove when you finish test
        if !!@timetable
            #erb :"/daycares/timetables/edit_timetable"
            redirect to "/timetable/#{@timetable.id}/edit"
        else
            erb :"/students/timetables/new_timetable"
        end
=end
        end
    end

    post '/timetable/:id' do
        redirect_if_not_logged_in 
        @error_message = params[:error]

        @error = false
        #@user = current_user
        @student = Student.find(params[:id])
        @daycare = Daycare.find(@student.daycare_id.to_s)

        if params[:check_in] == "" && params[:check_out] == "" && params[:absence] == nil
            redirect to "/timetable/#{@student.id}/new"
            #erb :'/daycares/timetables/new_timetable'
        elsif params[:absence] == true && params[:check_in] != ""
            @error = true
            @error_msg = "If you checked [Absence Check-box], it is not able to input Check-in."
            erb :"/students/timetables/new_timetable"
        elsif params[:absence] == true && params[:check_out] != ""
            @error = true
            @error_msg = "If you checked [Absence Check-box], it is not able to input Check-out."
            erb :"/students/timetables/new_timetable"
        elsif params[:check_in] == "" && params[:check_out] != ""
            @error = true
            @error_msg = "You are missing Check-in."
            erb :"/students/timetables/new_timetable"
        else
            @timetable = Timetable.create(:date => Time.now.strftime("%m/%d/%Y"), 
                                        :check_in => params[:check_in], 
                                        :check_out => params[:check_out], 
                                        :report => params[:report], 
                                        :absence => params[:absence], 
                                        :student_id => params[:id])
            
            @error = true
            @error_msg = "You successfully changed the timetable."
            erb :'/students/timetables/edit_timetable'
            #redirect to "/timetable/#{@timetable.id}/edit"
        end
    end

    #edit timetable
    get '/timetable/:id/edit' do
        redirect_if_not_logged_in 
        @error_message = params[:error]
        if admin_user?
            redirect to '/daycare/show'
        else
            @timetable = Timetable.find(params[:id])
            @student = Student.find(@timetable.student_id.to_s)
            @daycare = Daycare.find(@student.daycare_id.to_s)
            
            erb :'/students/timetables/edit_timetable'
        end
    end

    patch '/timetable/:id' do
        redirect_if_not_logged_in 
        @error_message = params[:error]

        @user = current_user
        #@student = Student.find(params[:id])
        #@daycare = Daycare.find_by(:id => @student.daycare_id.to_s)
        @timetable = Timetable.find(params[:id])
        @student = Student.find(@timetable.student_id.to_s)
        @daycare = Daycare.find(@student.daycare_id.to_s)
          
        if params[:absence] == "true" && params[:check_in] != ""
            @error = true
            @error_msg = "If you checked [Absence Check-box], it is not able to input Check-in."
            erb :'/students/timetables/edit_timetable'
        elsif params[:absence] == "true" && params[:check_out] != ""
            @error = true
            @error_msg = "If you checked [Absence Check-box], it is not able to input Check-out."
            erb :'/students/timetables/edit_timetable'
        elsif @timetable.date != Time.now.strftime("%m/%d/%Y")
            redirect to "/timetable/#{@student.id}/new"
        elsif params[:check_in] == "" && params[:check_out] != ""
            @error = true
            @error_msg = "You are missing Check-in."
            erb :'/students/timetables/edit_timetable'
        else
            @timetable.check_in = params[:check_in] if @timetable.check_in != params[:check_in]
            @timetable.check_out = params[:check_out] if @timetable.check_out != params[:check_out]
            @timetable.absence = params[:absence] if @timetable.absence != params[:absence]
            @timetable.report = params[:report] if @timetable.report != params[:report]
            @timetable.save
            @error = true
            
            @error_msg = "You successfully changed the timetable."
            #erb :'/daycares/timetables/edit_timetable'#, locals: {message: "You are missing information"}
            erb :'/students/timetables/edit_timetable'
        end
    end
    
end