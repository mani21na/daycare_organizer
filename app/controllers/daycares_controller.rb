class DaycaresController < ApplicationController
    #Daycare main page
    get '/daycare/:id' do
        redirect_if_not_logged_in
        @error_message = params[:error]

        @user = current_user
        @student = Student.find(params[:id])
        @daycare = Daycare.find_by(:id => @student.daycare_id.to_s)

        erb :"/daycares/main_daycare"
    end

    
end