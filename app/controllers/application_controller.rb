class ApplicationController < Sinatra::Base

    #This configure block tells the controller 
    #where to look to find the views and the public directory.
    configure do
        set :public_folder, 'public'
        set :views, 'app/views'
        enable :sessions
        set :session_secret, "golfclubsaregreat"
    end

    get '/' do 
        erb :index
        #welcome to TEST!!! 
    end
end