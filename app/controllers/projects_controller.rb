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
        @config = ApplicationConfiguration.last
        puts "After submission start?: #{Time.now > @config.class_project_submission_start}"
        puts "Before submission end?: #{Time.now < @config.class_project_submission_end}"
        @online = Time.now > @config.class_project_submission_start && Time.now < @config.class_project_submission_end
        puts "Online?: #{@online}"
        
        # Director can use the form even if it is offline
        if (@online || current_user.director?)
            flash.now[:warning] = @config.class_project_before_deadline_message
            render "#{@view_path}/new"
        else
            flash.now[:danger] = @config.class_project_after_deadline_message
            render 'form_offline'
        end
    end
    
    def create
        
        @project = Project.new(create_params)
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
        
        if @project.update_attributes(update_params)
            flash[:success] = "#{@project.name} has been successfully updated!"
            redirect_to project_path(@project)
        else
            flash.now[:danger] = "Sorry, but there were errors in your project. Please correct them before submitting again."
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
    
    def create_params
        params.require(:project).permit(policy(Project).create_attributes)
    end
    
    def update_params
        params.require(:project).permit(policy(@project).update_attributes)
    end
end
