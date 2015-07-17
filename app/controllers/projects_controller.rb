class ProjectsController < ApplicationController
    
    def new
        @project = Project.new
    end
    
    def create
        @project = Project.new(project_params)
        
        puts "Project: " + @project.to_s
        
        if @project.save
            flash[:success] = "Your project, " + @project.name + ", has been successfully submitted!"
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
