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
        @project = Project.new(project_params)
        
        puts "Project: " + @project.to_s
        
        if @project.save
            flash[:success] = "Your project, #{@project.name}, has been successfully submitted!"
            redirect_to root_path
        else
            render 'new'
        end
    end
    
    private
    
    def project_params
        params.require(:project).permit(:course_id, :category, :name, :description, :script_due, :due, :viewable_by)
    end
end
