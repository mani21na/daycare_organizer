class UsersController < ApplicationController
    #signup page
    get '/signup' do
        erb :'users/new'
    end
    
    #create new user
    post '/users' do
        #check uniqueness id?

        #create new user from M
        if params[:username] == "" || params[:password] == ""
            @error_msg = true
            redirect to '/signup'
          else
            @user = User.create(:username => params[:username], :password => params[:password])
            session[:user_id] = @user.id
            redirect '/show'
          end
        #check params

        #redirect to ('/show')
    end

    #login
    post '/login' do
        @user = User.find_by(:login_id => params[:login_id], :password => params[:password])
        @error_msg = false
        if user && user.authenticate(params[:password])
            session[:user_id] = user.login_id
            redirect '/dashboard'
          else
            @error_msg = true
            redirect to '/index'
          end
          @error_msg = false
        end


end