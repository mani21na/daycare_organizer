class UsersController < ApplicationController
  #Signup page
  get '/signup' do
    erb :'users/new'
  end
  
  #Create new user
  post '/user' do
    @error = false

    if params[:username] == "" || params[:password] == ""
      @error = true
      @error_msg = "Input Username And Password. Try Again"
      erb :'users/new'
    elsif !!User.find_by(:username => params[:username])
      @error = true
      @error_msg = "Try Another Username Again"
      erb :'users/new'
    elsif params[:first_name] == "" || params[:last_name] == "" || params[:phone] == "" || params[:address] == "" || params[:relationship] == "" || params[:alternative_phone] == ""
      @error = true
      @error_msg = "Please Fill In All Items"
      erb :'users/new'
    elsif params[:alternative_phone] == params[:phone]
      @error = true
      @error_msg = "Input Alternative Telephone"
      erb :'users/new'
    else
      @user = User.create(:username => params[:username], 
                          :password => params[:password], 
                          :first_name => params[:first_name].upcase, 
                          :last_name => params[:last_name].upcase, 
                          :phone => params[:phone], 
                          :address => params[:address],
                          :relationship => params[:relationship],
                          :alternative_phone => params[:alternative_phone])
      session[:user_id] = @user.id
      erb :'users/main'
    end
  end

  #Login
  post '/login' do
      @user = User.find_by(:username => params[:username])
      @error_msg = false
      if @user && @user.authenticate(params[:password])
          session[:user_id] = @user.id
          #erb :'users/main'
          redirect to "/show"
      else
          @error_msg = true
          erb :index
      end
  end

  get '/show' do
    if !logged_in?
      redirect to '/'
    end
    @user = current_user
    erb :'users/main'
  end
  
  #Logout
  get '/logout' do
    if session[:user_id] != nil
      session.destroy
      redirect to '/'
    else
      redirect to '/'
    end
  end

  #User Account Edit
  get '/user/account/edit' do
    redirect_if_not_logged_in 
    @error_message = params[:error]

    @user = current_user
    erb :"users/edit_user"
  end

  patch '/user/edit' do
    redirect_if_not_logged_in 
    @error_message = params[:error]

    @user = current_user
    @error = false

    if !!User.find_by(:username => params[:username]) && @user.username != params[:username]
      @error = true
      @error_msg = "The username that you input is already registered."
 
      erb :"users/edit_user"
    elsif params[:password] == ""
      @error = true
      @error_msg = "Input Password. Try Again"

      erb :"users/edit_user"
    elsif params[:first_name] == "" || params[:last_name] == "" || params[:phone] == "" || params[:address] == "" || params[:relationship] == "" || params[:alternative_phone] == ""
      @error = true
      @error_msg = "Please Fill In All Items"

      erb :"users/edit_user"
    elsif params[:alternative_phone] == params[:phone]
      @error = true
      @error_msg = "Input Alternative Telephone"

      erb :"users/edit_user"
    else
      @user.username = params[:username] if @user.username != params[:username]
      @user.password = params[:password] if @user.password != params[:password]
      @user.first_name = params[:first_name].upcase if @user.last_name != params[:last_name]
      @user.last_name = params[:last_name].upcase if @user.last_name != params[:last_name]
      @user.phone = params[:phone] if @user.phone != params[:phone]
      @user.address = params[:address] if @user.address != params[:address]
      @user.relationship = params[:relationship] if @user.relationship != params[:relationship]
      @user.alternative_phone = params[:alternative_phone] if @user.alternative_phone != params[:alternative_phone]
      @user.save
      
      @error = true
      @error_msg = "You successfully changed user settings."
      
      erb :"users/edit_user"
    end
  end
end