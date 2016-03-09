class StandardActivitiesController < ApplicationController
    
    before_action :set_standard_activity, only: [:show, :edit, :update, :destroy]

    def index
        
        @standard_activities = policy_scope(StandardActivity)
    end

    def new
        
        @standard_activity = StandardActivity.new
        authorize @standard_activity
    end

    def create
        
        @standard_activity = StandardActivity.new(create_params)
        authorize @standard_activity

        if @standard_activity.save
            flash[:success] = t "#{controller_name.singularize}.#{action_name}.success", scope: "forms", start: @standard_activity.start
            redirect_to @standard_activity
        else
            flash[:danger] = t :submission_errors, scope: "forms"
            render :new
        end
    end
    
    def show
        
        authorize @standard_activity
    end
    
    def edit
        
        authorize @standard_activity
    end

    def update
        
        authorize @standard_activity
      
        if @standard_activity.update(update_params)
            flash[:success] = t "#{@i18n_path}.success", scope: "forms", start: @standard_activity.start
            redirect_to @standard_activity
        else
            flash[:danger] = t "submission_errors", scope: "forms"
            render :edit
        end
    end

    def destroy
        
        authorize @standard_activity
        
        if @standard_activity.destroy
            flash[:success] = t "#{@i18n_path}.success", scope: "forms", start: @standard_activity.start
            redirect_to standard_activities_url
        else
            render :edit
        end
    end

    private

    def set_standard_activity
        @standard_activity = StandardActivity.find(params[:id])
    end
    
    def create_params
        params.require(:standard_activity).permit(policy(StandardActivity).create_attributes)
    end
    
    def update_params
        params.require(:standard_activity).permit(policy(@standard_activity).update_attributes)
    end
end
