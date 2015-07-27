class ProjectsController < ApplicationController
    
    def new
        @project = Project.new
        @num_training = Project::CATEGORY_TRAINING_EVENTS.values[0]
        @num_editing = Project::CATEGORY_EDITING_EVENTS.values[0]
        
        @num_training.times { @project.project_reservations.build :category => ProjectReservation.categories[:training] }
        @num_editing.times { @project.project_reservations.build :category => ProjectReservation.categories[:editing] }
        
        puts "Project: #{@project.project_reservations.length}"
    end
    
    def create
        
        proj = params[:project]
        # Convert the DateTimePicker text values for Project to a DateTime object
        date_time_params = %i(script_due due viewable_by)
        convert_date_time_picker_values(proj, date_time_params)
        
        # Convert the DateTimePicker text values for ProjectReservations to a DateTime object
        date_time_params = %i(start end)
        reservations = proj[:project_reservations_attributes].select { |index, res| res[:_destroy] == "false" && (!res[:start].blank? && !res[:end].blank?) }
        reservations.each do |index, res|
            convert_date_time_picker_values(res, date_time_params)
            res[:lab] = Lab.locations[res[:lab]]
        end
        
        @project = Project.new(project_params)
        
        if @project.save
            flash[:success] = "Your project, #{@project.name}, has been successfully submitted!"
            redirect_to root_path
        else
            puts "Errors: #{@project.errors.messages}"
            render 'new'
        end
    end
    
    private
    
    def project_params
        params.require(:project).permit(:course_id, :category, :name, :description, :script_due, :due, :viewable_by, project_reservations_attributes: [:start, :end, :lab, :_destroy])
    end
end
