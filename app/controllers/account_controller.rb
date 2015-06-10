class AccountController < ApplicationController
    
    # Secure login:
    # http://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html#method-i-has_secure_password
    # https://github.com/leesmith/decent_authentication
    # https://gist.github.com/thebucknerlife/10090014
    
    # The home page. Nothing special except a login form
    def home
        @title = "Home"
    end
    
    # POST login, attempt to log the user in, redirect if it's their first time
    def login
        @username = params[:username]
        @password = params[:password]
        
        @user = User.find_by username: @username
        puts "USER FOUND?: #{@user.username}"
        
        if @password.empty?
            # Store username in session, then clear it after the password has been set
            session[:username] = @username
            redirect_to "/account/create"
        else
            puts "Password: #{@password}"
        end
    end
    
    # GET create, render form to set user's new password
    def first_login
        @username = session[:username]
        
        render "first_login"
    end
    
    # POST create, set the user's new password. Make sure they match
    def create
        @username = params[:username]
        @password = params[:password]
        @confirm_password = params[:password_confirmation]
        
        puts "[CREATE] Username: #{@username} --> #{@password} || #{@password_confirmation}"
        
        if @password == @password_confirmation
            puts "Passwords matched"
        else
            puts "Passwords did not match"
        end
        
        render "home"
    end
    
    private
    
    def login_params 
        params.require(:username).permit(:password)
    end
    
    def create_params 
        params.require(:username).require(:password).require(:confirm_password)
    end

end
