class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!

    # GET /users
    def index
        authorize User
        @limit = 50
        @order = { last_name: :asc }
        @includes = [:courses]

        @where = {}
        @where[:role] = params[:role] if params[:role].present?
        @where[:active_courses] = params[:active_courses] if params[:active_courses].present?
        @where[:archived] = params[:archived] if params[:archived].present?

        if params[:search].present?
            @users = User.search(
                params[:search],
                include: @includes,
                fields: [
                    :username,
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
            params[:user].permit(:username, :first_name, :last_name, :role, :registered, course_ids: [])
        end
end
