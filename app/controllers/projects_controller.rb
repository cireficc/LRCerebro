class ProjectsController < ApplicationController
    
    def index
        @projects = policy_scope(Project).where(archived: false)
        @approved = @projects.where(approved: true)
        @pending = @projects.where(approved: false)
    end
    
    def archive_index
        @projects = policy_scope(Project).where(archived: true)
        render 'archive_index'
    end
    
    def new
        @project = Project.new
        authorize @project
        @num_training = Project::CATEGORY_TRAINING_EVENTS.values[0]
        @num_editing = Project::CATEGORY_EDITING_EVENTS.values[0]
        
        @num_training.times { @project.project_reservations.build :category => ProjectReservation.categories[:training] }
        @num_editing.times { @project.project_reservations.build :category => ProjectReservation.categories[:editing] }
        
        # Check to see if the form is offline and act appropriately
        @config = YAML.load_file(File.join(Rails.root, 'config', 'lrc_settings.yml'))
        @class_project = @config["class_project"]
        @online = @class_project["online"]
        @offline_message = @class_project["offline_message"]
        @deadline_message = @class_project["deadline_message"]
        
        # Director and labasst can use the form even if it is offline
        if (@online || current_user.director? || current_user.labasst?)
            flash.now[:warning] = @deadline_message
            render "#{@view_path}/new"
        else
            render 'static_pages/form_offline'
        end
    end
    
    def create
        
        @project = Project.new(project_params)
        authorize @project
        
        if @project.save
            flash[:success] = "Your project, #{@project.name}, has been successfully submitted!"
            redirect_to root_path
        else
            flash.now[:danger] = "Sorry, but there were errors in your project. Please correct them before submitting again."
            render "#{@view_path}/new"
        end
    end
    
    def show
        @project = Project.find(params[:id])
        authorize @project
        
        # Set the present check-box so that it is checked properly when the form is rendered
        @project.present = "1" if !@project.viewable_by.nil?
        
        render "#{@view_path}/show"
    end
    
    def edit
        @project = Project.find(params[:id])
        authorize @project
        @project.present = "1" if !@project.viewable_by.nil?
        
        render "#{@view_path}/edit"
    end
    
    def update
        @project = Project.find(params[:id])
        authorize @project
        
        if @project.update_attributes(project_update_params)
            flash[:success] = "#{@project.name} has been successfully updated!"
            redirect_to project_path(@project)
        else
            flash.now[:danger] = generate_errors_html(Project, @project.errors.messages)
            render "#{@view_path}/edit"
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
            render "#{@view_path}/edit"
        end
    end
    
    private
    
    def project_params
        params.require(:project).permit(:course_id, :category, :name, :description, :script_due, :due, :present, :viewable_by,
            project_reservations_attributes: [:id, :category, :start, :end, :lab, :subtype, :staff_notes, :faculty_notes, :_destroy])
    end
    
    def project_update_params
        params.require(:project).permit(policy(@project).permitted_attributes)
    end
end
