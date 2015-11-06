class ProjectsController < ApplicationController
    
    def index
        @projects = policy_scope(Project)
        @approved = Array.new
        @pending = Array.new
        
        @projects.each do |p|
           if p.approved
               @approved << p
           else
               @pending << p
           end
        end
    end
    
    def new
        @project = Project.new
        authorize @project
        @num_training = Project::CATEGORY_TRAINING_EVENTS.values[0]
        @num_editing = Project::CATEGORY_EDITING_EVENTS.values[0]
        
        @num_training.times { @project.project_reservations.build :category => ProjectReservation.categories[:training] }
        @num_editing.times { @project.project_reservations.build :category => ProjectReservation.categories[:editing] }
        
        puts "Project: #{@project.project_reservations.length}"
    end
    
    def create
        
        @project = Project.new(project_params)
        authorize @project
        
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
        authorize @project
        
        # Set the present check-box so that it is checked properly when the form is rendered
        @project.present = "1" if !@project.viewable_by.nil?
    end
    
    def edit
        @project = Project.find(params[:id])
        authorize @project
        @project.present = "1" if !@project.viewable_by.nil?
    end
    
    def update
        @project = Project.find(params[:id])
        authorize @project
        
        if @project.update_attributes(project_update_params)
            flash[:success] = "#{@project.name} has been successfully updated!"
            redirect_to project_path(@project)
        else
            flash.now[:danger] = generate_errors_html(Project, @project.errors.messages)
            render 'edit'
        end
    end
    
    def destroy
        @project = Project.find(params[:id])
        authorize @project
        
        if @project.destroy
            flash[:success] = "#{@project.name} has been successfully deleted!"
            redirect_to projects_path
        else
            flash.now[:danger] = generate_errors_html(Project, @project.errors.messages)
            render 'edit'
        end
    end
    
    private
    
    def project_params
        params.require(:project).permit(:course_id, :category, :name, :description, :script_due, :due, :present, :viewable_by,
            project_reservations_attributes: [:id, :category, :start, :end, :lab, :staff_notes, :faculty_notes, :_destroy])
    end
    
    def project_update_params
        params.require(:project).permit(policy(@project).permitted_attributes)
    end
end
