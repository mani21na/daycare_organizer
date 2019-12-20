class UsersController < ApplicationController
    #signup
    get '/signup' do
        erb :'users/new'
    end
    
    #login
    get '/login' do
        erb :'users/login'
    end

end