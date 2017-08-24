class MiniProjectsController < ApplicationController

  def index

    authorize MiniProject
    
    @limit = 50
    @order = { start_date: :desc }
    @includes = [:course]

    @where = {}
    @where[:submitted_by] = params[:submitted_by] if params[:submitted_by].present?
    @where[:course] = params[:course] if params[:course].present?
    # Default archived to false if it hasn't been selected out yet
    params[:archived] = false if params[:archived].blank?
    @where[:archived] = params[:archived]

    # Hack Elasticsearch to gain back the functionality that we had with Pundit scoping
    # Director/labasst have full access to all projects, faculty/students only to their own
    @where[:members] = current_user.id if (current_user && (current_user.faculty? || current_user.student?))

    @mini_projects = MiniProjectDecorator.decorate_collection(MiniProject.search(
        "*",
        includes: @includes,
        where: @where,
        order: @order, page: params[:page], per_page: @limit
    ))
  end

  def new

    @mini_project = MiniProject.new
    authorize @mini_project
  end

  def create

    @mini_project = MiniProject.new(create_params)
    authorize @mini_project

    if @mini_project.save
      @submit_another_html = view_context.link_to("Submit another mini project", new_mini_project_path, {class: 'btn btn-info'})
      flash[:success] = t "#{@i18n_path}.success", scope: "forms", course: @mini_project.course.decorate.short_name,
                          resources: @mini_project.decorate.stringified_resources, submit_another_html: @submit_another_html
      redirect_to mini_projects_path
    else
      flash[:danger] = t :submission_errors, scope: "forms"
      render :new
    end
  end

  def show
    @mini_project = MiniProject.find(params[:id]).decorate
    authorize @mini_project

    # Set the present check-box so that it is checked properly when the form is rendered
    @mini_project.present = "1" if !@mini_project.publish_by.nil?
  end

  def edit
    @mini_project = MiniProject.find(params[:id]).decorate
    authorize @mini_project
    @mini_project.present = "1" if !@mini_project.publish_by.nil?
  end

  def update
    @mini_project = MiniProject.find(params[:id])
    authorize @mini_project

    if @mini_project.update_attributes(update_params)
      flash[:success] = t "#{@i18n_path}.success", scope: "forms", course: @mini_project.course.decorate.short_name
      redirect_to mini_project_path(@mini_project)
    else
      flash[:danger] = t :submission_errors, scope: "forms"
      render :edit
    end
  end

  def destroy
    @mini_project = MiniProject.find(params[:id])
    authorize @mini_project

    @mini_project.destroy
    flash[:success] = t "#{@i18n_path}.success", scope: "forms", course: @mini_project.course.decorate.short_name
    redirect_to mini_projects_path
  end

  private

  def create_params
    params.require(:mini_project).permit(policy(MiniProject).create_attributes)
  end

  def update_params
    params.require(:mini_project).permit(policy(@mini_project).update_attributes)
  end
end
