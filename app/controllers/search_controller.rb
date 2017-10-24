class SearchController < ApplicationController

  def index
    
    authorize :search, :index?

    @order = { course: :desc }
    @includes = [:course]

    @where = {}
    @where[:submitted_by] = params[:submitted_by] if params[:submitted_by].present?
    @where[:course] = params[:course] if params[:course].present?
    # Default year and semester if they haven't been selected yet
    params[:year] = ApplicationConfiguration.last.current_semester_year if params[:year].blank?
    @where[:year] = params[:year]
    params[:semester] = ApplicationConfiguration.last.current_semester if params[:semester].blank?
    @where[:semester] = params[:semester]

    # Hack Elasticsearch to gain back the functionality that we had with Pundit scoping
    # Director/labasst have full access to all resources, faculty only to their own
    @where[:members] = current_user.id if (current_user && (current_user.faculty? || current_user.student?))
    
    # Search criteria is the same for all multi-search resources (Project, MiniProject, StandardReservation, etc.)
    @search_criteria = {
        includes: @includes,
        where: @where,
        order: @order
    }
    
    @projects = ProjectDecorator.decorate_collection(Project.search(@search_criteria))
    @mini_projects = MiniProjectDecorator.decorate_collection(MiniProject.search(@search_criteria))
    @standard_reservations = StandardReservationDecorator.decorate_collection(StandardReservation.search(@search_criteria))
    @film_digitizations = FilmDigitizationDecorator.decorate_collection(FilmDigitization.search(@search_criteria))
    @vidcams = VidcamDecorator.decorate_collection(Vidcam.search(@search_criteria))
    @works = WorkDecorator.decorate_collection(Work.search(@search_criteria))
  end
end
