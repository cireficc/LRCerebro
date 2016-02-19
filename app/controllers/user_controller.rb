class UserController < ApplicationController
    
    # The login form page
    def login
        @title = "Login"
        @config = YAML.load_file(File.join(Rails.root, 'config', 'lrc_settings.yml'))
        flash.now[:warning] = @config["login"]["data_warning"]
        render "login"
    end
    
    def start_session
        
        @username = params[:user][:username]
        @password = params[:user][:password]
        
        @user = User.find_by(username: @username)
        
        # The BB username was not found; render the login form again with an error
        if @user.nil?
            flash.now[:danger] = "Your Blackboard username [#{@username}] was not found"
            return render "login"
        end
        
        # The BB username was found. Redirect to the sign-in form if they are not registered
        if !@user.registered?
            # Store username in session, then clear it after the password has been set
            # Redirect to set password page
            flash.now[:warning] =
            "This is the first time you are logging in; please register your account. Please note that
             this system uses your Blackboard username and g number, but does not log into Blackboard
             directly. You will only need to register once."
            session[:username] = @user.username
            return redirect_to signup_url
        end
        
        # Attempt to authenticate the user. On failure, error out
        if !@user.authenticate(@password)
            flash.now[:danger] = "Invalid login credentials"
            return render "login"
        else
            flash[:success] = "Hello #{@user.first_name}, you have been logged in!"
            # Set the session data via the AccountHelper method
            log_in @user
            return redirect_to root_url
        end
    end
    
    def signup
        @user = User.find_by(username: session[:username])
        @user.g_number = nil
        @title = "Sign Up"
        @config = YAML.load_file(File.join(Rails.root, 'config', 'lrc_settings.yml'))
        flash.now[:warning] = @config["login"]["data_warning"]
        render "signup"
    end
    
    def signup_and_start_session
        
        @_user = params[:user]
        @username = @_user[:username]
        @g_number = @_user[:g_number].downcase
        @password = @_user[:password]
        @password_confirmation = @_user[:password_confirmation]
        
        @user = User.find_by(username: @username, g_number: @g_number)
        
        # If the user could not be found by username and g number, error out
        if @user.nil?
            flash.now[:danger] = "Your Blackboard username [#{@username}] and G number [#{@g_number}] were not valid"
            return render "signup"
        end
        
        if @user.registered?
            flash.now[:danger] = "You have already registered. Please log in instead"
            return redirect_to login_url
        end
        
        # If the password was empty, error out
        if @password.blank?
            flash.now[:danger] = "Your new password cannot be blank"
            return render "signup"
        end
        
        @user.password = @password
        @user.password_confirmation = @password_confirmation
        @user.registered = true
        
        # Try to save the user's new password and registered status. User.has_secure_password will validate as necessary
        if !@user.save
            flash.now[:danger] = "Your passwords did not match, or you exceeded the length limit of 72 characters"
            return render "signup"
        else
            # Set up the user's session, strip out the temporary session variables and redirect home
            flash[:success] = "Hello #{@user.first_name}, your password has been set and you have been logged in!"
            # Remove the temporary user and set the session data via the AccountHelper method
            session.delete(:user)
            log_in @user
            redirect_to root_url
        end
    end
    
    def end_session
        log_out
        return redirect_to root_url
    end
end