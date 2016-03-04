class StandardActivitiesController < ApplicationController
    
    before_action :set_standard_activity, only: [:show, :edit, :update, :destroy]

    def index
        @standard_activities = StandardActivity.all
    end

    def show
    end

    def new
        @standard_activity = StandardActivity.new
    end

    def edit
    end

    def create
        @standard_activity = StandardActivity.new(standard_activity_params)

        if @standard_activity.save
        redirect_to @standard_activity
        else
        render :new
        end
    end

    def update
      
        if @standard_activity.update(standard_activity_params)
        redirect_to @standard_activity
        else
        render :edit
        end
    end

    def destroy
        @standard_activity.destroy
        redirect_to standard_activities_url
    end

    private

        def set_standard_activity
            @standard_activity = StandardActivity.find(params[:id])
        end

    def standard_activity_params
        params.require(:standard_activity).permit(:activity, :start, :end, :lab, :walkthrough, :additional_instructions, utilities: [], assistances: [])
    end
end
