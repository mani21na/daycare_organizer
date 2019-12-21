class UsersController < ApplicationController
    #signup page
    get '/signup' do
        erb :'users/new'
    end
    
    #create new user
    post '/users' do
        #check uniqueness id?

        #create new user from M
        new_user = User.new(:username => params[:username], :email => params[:email], :profile_pic => params[:profile_pic], :age => params[:age])
        new_user.save
        redirect ('/users')
        #check params

        #redirect to ('/show')
    end

    #login
    post '/login' do
        @user = User.find_by(:username => params[:username], :password => params[:password])
        if @user
            session[:user_id] = @user.id
            redirect('/show')
        else 
            erb :error
        end
    end


end