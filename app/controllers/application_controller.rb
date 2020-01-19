class ApplicationController < Sinatra::Base

    #This configure block tells the controller 
    #where to look to find the views and the public directory.
    configure do
        set :public_folder, 'public'
        set :views, 'app/views'
        enable :sessions
        set :session_secret, "daycareorga_secret"
    end

    get '/' do 
      if session[:user_id] != nil
        session.destroy
        erb :index
      else
        erb :index
      end
    end

    helpers do
        def redirect_if_not_logged_in
          if !logged_in?
            redirect to "/?error=You have to be logged in to do that"
          end
        end
    
        def logged_in?
          !!session[:user_id]
        end
    
        def current_user
          User.find(session[:user_id])
        end
    
        def not_admin_user?
          current_user.admin_flag == nil
        end

        def daycare_admin_user?
          current_user.admin_flag == 2
        end

        def admin_user?
          current_user.admin_flag == 1
        end
      end
end