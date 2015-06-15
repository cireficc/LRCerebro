class AccountController < ApplicationController
    
    # Secure login:
    # http://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html#method-i-has_secure_password
    # https://github.com/leesmith/decent_authentication
    # https://gist.github.com/thebucknerlife/10090014
    
    # The login form page
    def home
        @title = "Login"
        render "login"
    end
    
    # POST login, attempt to log the user in, redirect if it's their first time
    def login
        @username = params[:username]
        @password = params[:password]
        
        @user = User.find_by username: @username
        
        # The BB username was not found; render the login form again with an error
        if @user.nil?
            flash.now[:danger] = "Your Blackboard username [#{@username}] was not found"
            return render "login"
        end
        
        # The BB username was found. Check to see if their password has been set before
        if @user.password_digest.blank?
            # Store username in session, then clear it after the password has been set
            # Redirect to set password page
            session[:username] = @username
            flash.now[:warning] =
            "This is the first time you are logging in; please register your account. Please note that
             this system uses your Blackboard username and g number, but does not log into Blackboard
             directly."
            @signup = true
            return render "login"
        end
        
        # Attempt to authenticate the user. On failure, error out
        if !@user.authenticate(@password)
            flash[:danger] = "Invalid login credentials"
            return render "login"
        else
            flash[:success] = "Hello #{@username}, you have been logged in!"
            # Set the session data via the AccountHelper method
            log_in @user
            return redirect_to root_url
        end
        
    end
    
    # POST create, set the user's new password. Make sure they match and are not empty
    def create
        @username = params[:username]
        @g_number = params[:g_number].downcase
        @password = params[:password]
        @password_confirmation = params[:password_confirmation]
        # This variable tells the login view's JavaScript to switch to the Sign Up tab
        @signup = true
        
        puts "[CREATE] Username: #{@username} --> #{@g_number} || #{@password} || #{@password_confirmation}"
        
        @user = User.find_by username: @username, g_number: @g_number
        
        # If the user could not be found by username and g number, error out
        if @user.nil?
            flash.now[:danger] = "Your Blackboard username [#{@username}] and G number [#{@g_number}] were not valid"
            return render "login"
        end
        
        if !@user.password_digest.blank?
            flash.now[:danger] = "You have already registered. Please log in instead"
            # Nullify sign-up variables because the user has already registered
            @signup = nil
            @g_number = nil
            return render "login"
        end
        
        # If the password was empty, error out
        if @password.blank?
            flash.now[:danger] = "Your new password cannot be blank (or contain only whitespaces)"
            return render "login"
        end
        
        @user.password = @password
        @user.password_confirmation = @password_confirmation
        
        # Try to save the user's new password. User.has_secure_password will validate as necessary
        if !@user.save
            flash.now[:danger] = "Your passwords did not match, or you exceeded the length limit of 72 characters"
            return render "login"
        else
            # Set up the user's session, strip out the temporary session variables and redirect home
            flash[:success] = "Hello #{@username}, your password has been set and you have been logged in!"
            # Set the session data via the AccountHelper method
            log_in @user
            redirect_to root_url
        end
    end
    
    def logout
        log_out
        return redirect_to root_url
    end
end
