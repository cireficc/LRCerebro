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
        
        if @project.save
            flash[:success] = "Your project, #{@project.name}, has been successfully submitted!"
            redirect_to root_path
        else
            flash.now[:danger] = generate_errors_html(Project, @project.errors.messages)
            render 'new'
        end
    end
    
    def show
        @project = Project.find(params[:id])
        # Set the present check-box so that it is checked properly when the form is rendered
        @project.present = "1" if !@project.viewable_by.nil?
    end
    
    def edit
        @project = Project.find(params[:id])
        @project.present = "1" if !@project.viewable_by.nil?
    end
    
    def update
        @project = Project.find(params[:id])
        
        if @project.update_attributes(project_params)
            flash[:success] = "#{@project.name} has been successfully updated!"
            redirect_to project_path(@project)
        else
            flash.now[:danger] = generate_errors_html(Project, @project.errors.messages)
            render 'edit'
        end
    end
    
    private
    
    def project_params
        params.require(:project).permit(:course_id, :category, :name, :description, :script_due, :due, :present, :viewable_by, project_reservations_attributes: [:id, :category, :start, :end, :lab, :_destroy])
    end
end
