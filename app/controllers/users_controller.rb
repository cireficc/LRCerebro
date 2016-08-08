class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    
    # The login form page
    def login
        
        if current_user
            redirect_to root_url
            return
        end
        
        @title = "Login"
        @config = ApplicationConfiguration.last
        flash.now[:warning] = @config.enrollment_update_message
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
            return redirect_to session[:last_page]
        end
    end
    
    def signup
        @user = User.find_by(username: session[:username])
        @user.g_number = nil if @user
        @title = "Sign Up"
        @config = ApplicationConfiguration.last
        flash.now[:warning] = @config.enrollment_update_message
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
            redirect_to session[:last_page]
        end
    end
    
    def end_session
        log_out
        return redirect_to root_url
    end

    # GET /users
    def index
        authorize User
        @limit = 50
        @order = { g_number: :asc }
        @includes = [:courses]

        @where = {}
        @where[:role] = params[:role] if params[:role].present?
        @where[:active_courses] = params[:active_courses] if params[:active_courses].present?
        
        if params[:archived].present?
            if params[:archived] == "true"
                @where[:year] = { not: ApplicationConfiguration.first.current_semester_year }
                @where[:semester] = { not: ApplicationConfiguration.first.current_semester }
            else
                @where[:year] = ApplicationConfiguration.first.current_semester_year
                @where[:semester] = ApplicationConfiguration.first.current_semester
            end
        end

        if params[:search].present?
            @users = User.search(
                params[:search],
                include: @includes,
                fields: [
                    :username,
                    {g_number: :exact},
                    :first_name,
                    :last_name,
                ],
                where: @where,
                order: @order, page: params[:page], per_page: @limit
            )
        else
            @users = User.search(
                "*",
                include: @includes,
                where: @where,
                order: @order, page: params[:page], per_page: @limit
            )
        end
    end

    # GET /users/1
    def show
        authorize User
    end

    # GET /users/new
    def new
        authorize User
        @user = User.new
    end

    # GET /users/1/edit
    def edit
        authorize User
    end

    # POST /users
    def create

        @user = User.new(user_params)
        authorize @user

        if @user.save
            flash[:success] = t "#{@i18n_path}.success", scope: "forms",
                                name: "#{@user.first_name} #{@user.last_name}"
            redirect_to users_path
        else
            render :new
        end
    end

    # PATCH/PUT /users/1
    def update

        authorize @user

        if @user.update(user_params)
            flash[:success] = t "#{@i18n_path}.success", scope: "forms", name: "#{@user.first_name} #{@user.last_name}"
            redirect_to user_path(@user)
        else
            render :edit
        end
    end

    # DELETE /users/1
    def destroy

        authorize @user

        @user.destroy
        flash[:success] = t "#{@i18n_path}.success", scope: "forms", name: "#{@user.first_name} #{@user.last_name}"
        redirect_to users_path
    end

    private

        def set_user
            @user = User.find(params[:id])
        end

        def user_params
            params[:user].permit(:username, :g_number, :first_name, :last_name, :role, :registered, course_ids: [])
        end
end
