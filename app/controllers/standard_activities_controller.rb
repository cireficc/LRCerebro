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
            redirect_to @standard_activity
        else
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
            redirect_to @standard_activity
        else
            render :edit
        end
    end

    def destroy
        
        authorize @standard_activity
        
        if @standard_activity.destroy
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
