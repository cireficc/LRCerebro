class ProjectsController < ApplicationController

  def index
    
    authorize Project
    
    @limit = 50
    @order = { created_at: :desc }
    @includes = [:course, :project_reservations]

    @where = {}
    @where[:category] = params[:category] if params[:category].present?
    @where[:submitted_by] = params[:submitted_by] if params[:submitted_by].present?
    @where[:course] = params[:course] if params[:course].present?
    @where[:script_due] = { lte: DateTime.parse(params[:script_due]) } if params[:script_due].present?
    @where[:due] = { lte: DateTime.parse(params[:due]) } if params[:due].present?
    @where[:first_training] = { lte: DateTime.parse(params[:first_training]) } if params[:first_training].present?
    @where[:last_editing] = { lte: DateTime.parse(params[:last_editing]) } if params[:last_editing].present?
    @where[:approved] = params[:approved] if params[:approved].present?
    # Default year and semester if they haven't been selected yet
    params[:year] = ApplicationConfiguration.last.current_semester_year if params[:year].blank?
    @where[:year] = params[:year]
    params[:semester] = ApplicationConfiguration.last.current_semester if params[:semester].blank?
    @where[:semester] = params[:semester]

    # Hack Elasticsearch to gain back the functionality that we had with Pundit scoping
    # Director/labasst have full access to all projects, faculty/students only to their own
    @where[:members] = current_user.id if (current_user && (current_user.faculty? || current_user.student?))

    if params[:search].present?
      @projects = ProjectDecorator.decorate_collection(Project.search(
          params[:search],
          includes: @includes,
          fields: [
              :name,
              :description
          ],
          where: @where,
          order: @order, page: params[:page], per_page: @limit
      ))
    else
      @projects = ProjectDecorator.decorate_collection(Project.search(
          "*",
          includes: @includes,
          where: @where,
          order: @order, page: params[:page], per_page: @limit
      ))
    end

    @approved = @projects.select { |p| p.approved }
    @pending = @projects.select { |p| !p.approved }
  end

  def archive_index
    @projects = policy_scope(Project).archived
    render 'archive_index'
  end

  def new
    @project = Project.new
    authorize @project

    # Check to see if the form is offline and act appropriately
    @config = ApplicationConfiguration.last
    # The date in the database is in UTC, but this is in local time. So we need to make sure they are both in UTC otherwise
    # the date comparisons are off by whatever the difference is between local time and UTC
    now = Time.now.asctime.in_time_zone('UTC')
    @online = now > @config.class_project_submission_start && now < @config.class_project_submission_end

    # Director can use the form even if it is offline
    if @online || current_user.director?
      flash.now[:warning] = @config.class_project_before_deadline_message
      render "#{@view_path}/new"
    else
      flash.now[:danger] = @config.class_project_after_deadline_message
      render 'partials/_form_offline'
    end
  end

  def create

    @project = Project.new(create_params)
    authorize @project

    if @project.save
      @submit_another_html = view_context.link_to("Submit another proposal", new_project_path, {class: 'btn btn-info'})
      flash[:success] = t "#{@i18n_path}.success", scope: "forms", name: @project.name, submit_another_html: @submit_another_html
      redirect_to projects_path
    else
      flash[:danger] = t :submission_errors, scope: "forms"
      render "#{@view_path}/new"
    end
  end

  def show
    @project = Project.find(params[:id]).decorate
    authorize @project

    # Set the present check-box so that it is checked properly when the form is rendered
    @project.present = "1" if !@project.publish_by.nil?

    render "#{@view_path}/show"
  end

  def edit
    @project = Project.find(params[:id]).decorate
    authorize @project
    @project.present = "1" if !@project.publish_by.nil?

    render "#{@view_path}/edit"
  end

  def update
    @project = Project.find(params[:id])
    authorize @project

    if @project.update_attributes(update_params)
      flash[:success] = t "#{@i18n_path}.success", scope: "forms", name: @project.name
      redirect_to project_path(@project)
    else
      flash[:danger] = t :submission_errors, scope: "forms"
      render "#{@view_path}/edit"
    end
  end

  def destroy
    @project = Project.find(params[:id])
    authorize @project

    @project.destroy
    flash[:success] = t "#{@i18n_path}.success", scope: "forms", name: @project.name
    redirect_to projects_path
  end

  private

  def create_params
    params.require(:project).permit(policy(Project).create_attributes)
  end

  def update_params
    params.require(:project).permit(policy(@project).update_attributes)
  end
end
