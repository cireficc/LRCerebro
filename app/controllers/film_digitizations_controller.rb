class FilmDigitizationsController < ApplicationController

  before_action :set_film_digitization, only: [:show, :edit, :update, :destroy]

  def index

    authorize FilmDigitization

    @limit = 25
    @order = { due_date: :desc }
    @includes = [:course, :film]

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

    @film_digitizations = FilmDigitizationDecorator.decorate_collection(FilmDigitization.search(
        "*",
        includes: @includes,
        where: @where,
        order: @order, page: params[:page], per_page: @limit
    ))
  end

  def new

    @film_digitization = FilmDigitization.new
    authorize @film_digitization

    # Director can use the form even if it is offline
    if form_submission_allowed? || current_user.director?
      render 'new'
    else
      render 'partials/_form_offline'
    end
  end

  def create

    @film_digitization = FilmDigitization.new(create_params)
    authorize @film_digitization

    if @film_digitization.save
      flash[:success] = t "#{@i18n_path}.success", scope: "forms", film_title: @film_digitization.decorate.full_title
      redirect_to film_digitizations_path
    else
      flash[:danger] = t :submission_errors, scope: "forms"
      render :new
    end
  end

  def show

    authorize @film_digitization
  end

  def edit

    authorize @film_digitization
  end

  def update

    authorize @film_digitization

    if @film_digitization.update(update_params)
      flash[:success] = t "#{@i18n_path}.success", scope: "forms", film_title: @film_digitization.decorate.full_title
      redirect_to film_digitizations_path
    else
      flash[:danger] = t "submission_errors", scope: "forms"
      render :edit
    end
  end

  def destroy

    authorize @film_digitization

    if @film_digitization.destroy
      flash[:success] = t "#{@i18n_path}.success", scope: "forms", film_title: @film_digitization.decorate.full_title
      redirect_to film_digitizations_path
    else
      render :edit
    end
  end

  private

  def set_film_digitization
    @film_digitization = FilmDigitization.find(params[:id])
  end

  def create_params
    params.require(:film_digitization).permit(policy(FilmDigitization).create_attributes)
  end

  def update_params
    params.require(:film_digitization).permit(policy(@film_digitization).update_attributes)
  end
end
