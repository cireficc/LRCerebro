class WorksController < ApplicationController

  before_action :set_work, only: [:show, :edit, :update, :destroy]

  def index

    authorize Work

    @limit = 25
    @order = { due_date: :desc }
    @includes = [:course]

    @where = {}
    @where[:course] = params[:course] if params[:course].present?
    @where[:submitted_by] = params[:submitted_by] if params[:submitted_by].present?

    # Hack Elasticsearch to gain back the functionality that we had with Pundit scoping
    # Director/labasst have full access to all standard reservations, faculty/students only to their own
    @where[:members] = current_user.id if (current_user && (current_user.faculty? || current_user.student?))
    # Default year and semester if they haven't been selected yet
    params[:year] = ApplicationConfiguration.last.current_semester_year if params[:year].blank?
    @where[:year] = params[:year]
    params[:semester] = ApplicationConfiguration.last.current_semester if params[:semester].blank?
    @where[:semester] = params[:semester]

    @works = WorkDecorator.decorate_collection(Work.search(
        "*",
        includes: @includes,
        where: @where,
        order: @order, page: params[:page], per_page: @limit
    ))
  end

  def new

    @work = Work.new
    authorize @work
  end

  def create

    @work = Work.new(create_params)
    authorize @work


    if @work.save
      flash[:success] = t "#{@i18n_path}.success", scope: "forms", course: @work.course.decorate.short_name
      redirect_to works_path
    else
      flash[:danger] = t :submission_errors, scope: "forms"
      render :new
    end
  end

  def show

    authorize @work
  end

  def edit

    authorize @work
  end

  def update

    authorize @work

    if @work.update(update_params)
      flash[:success] = t "#{@i18n_path}.success", scope: "forms", course: @work.course.decorate.short_name
      redirect_to works_path
    else
      flash[:danger] = t "submission_errors", scope: "forms"
      render :edit
    end
  end

  def destroy

    authorize @work

    if @work.destroy
      flash[:success] = t "#{@i18n_path}.success", scope: "forms", course: @work.course.decorate.short_name
      redirect_to works_path
    else
      render :edit
    end
  end

  private

  def set_work
    @work = Work.find(params[:id])
  end

  def create_params
    params.require(:work).permit(policy(Work).create_attributes)
  end

  def update_params
    params.require(:work).permit(policy(@work).update_attributes)
  end
end
