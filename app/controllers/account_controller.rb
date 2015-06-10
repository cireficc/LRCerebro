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
        
        # The BB username was not found; render the login form again with an error
        if @user.nil?
            flash.now[:error] = "Your Blackboard username [#{@username}] was not found"
            return render "home"
        end
        
        # The BB username was found. Check to see if their password has been set before
        if @password.empty? && @user.password_digest.blank?
            # Store username in session, then clear it after the password has been set
            # Redirect to set password page
            session[:username] = @username
            return redirect_to "/account/create"
        end
        
        # Attempt to authenticate the user. On failure, error out
        if @user.authenticate(@password)
            flash[:success] = "Hello #{@username}, you have been logged in!"
            # Set the session data
            
            return redirect_to "/"
        else
            flash[:error] = "Invalid login credentials"
            return render "home"
        end
        
    end
    
    # GET create, render form to set user's new password
    def first_login
        @username = session[:username]
        
        return render "first_login"
    end
    
    # POST create, set the user's new password. Make sure they match
    def create
        @username = params[:username]
        @g_number = params[:g_number].downcase
        @password = params[:password]
        @password_confirmation = params[:password_confirmation]
        
        puts "[CREATE] Username: #{@username} --> #{@g_number} || #{@password} || #{@password_confirmation}"
        
        @user = User.find_by username: @username, g_number: @g_number
        
        # If the user could not be found by username and g number, error out
        if @user.nil?
            flash.now[:error] = "Your Blackboard username [#{@username}] and G number [#{@g_number}] were not valid"
            return render "first_login"
        end
        
        # If the password was empty, error out
        if @password.empty?
            flash.now[:error] = "Your new password cannot be blank"
            return render "first_login"
        end
        
        @user.password = @password
        @user.password_confirmation = @password_confirmation
        
        # Try to save the user's new password. User.has_secure_password will validate as necessary
        if !@user.save
            flash.now[:error] = "Your passwords did not match, or you exceeded the length limit of 72 characters"
            return render "first_login"
        else
            # Set up the user's session, strip out the temporary session variables and redirect home
            flash[:success] = "Hello #{@username}, your password has been set and you have been logged in!"
            return redirect_to "/"
        end
    end
    
    private
    
    def login_params 
        params.require(:username).permit(:password)
    end
    
    def create_params 
        params.require(:username).require(:password).require(:confirm_password)
    end

end
