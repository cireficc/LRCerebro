class StandardReservationsController < ApplicationController

  before_action :set_standard_reservation, only: [:show, :edit, :update, :destroy]

  def index

    @limit = 25
    @order = { reservation_start: :desc }
    @includes = [:course]

    @where = {}
    @where[:course] = params[:course] if params[:course].present?
    @where[:submitted_by] = params[:submitted_by] if params[:submitted_by].present?
    @where[:activity] = params[:activity] if params[:activity].present?
    if params[:start].present? && params[:end].present?
      @where[:reservation_start] = { gte: DateTime.parse(params[:start]), lte: DateTime.parse(params[:end]) }
    elsif params[:start].present?
      @where[:reservation_start] = { gte: DateTime.parse(params[:start]) }
    else
      @where[:reservation_start] = { lte: DateTime.parse(params[:end]) } if params[:end].present?
    end
    @where[:lab] = params[:lab] if params[:lab].present?

    # Hack Elasticsearch to gain back the functionality that we had with Pundit scoping
    # Director/labasst have full access to all standard reservations, faculty/students only to their own
    @where[:members] = current_user.id if (current_user && (current_user.faculty? || current_user.student?))
    # Default archived to false if it hasn't been selected out yet
    params[:archived] = false if params[:archived].blank?
    @where[:archived] = params[:archived]

    @standard_reservations = StandardReservationDecorator.decorate_collection(StandardReservation.search(
        "*",
        includes: @includes,
        where: @where,
        order: @order, page: params[:page], per_page: @limit
    ))

    @past = @standard_reservations.select { |r| r.start < ApplicationHelper.local_to_utc(Time.now) }
    @upcoming = @standard_reservations.select { |r| r.start >= ApplicationHelper.local_to_utc(Time.now) }
  end

  def new

    @standard_reservation = StandardReservation.new
    authorize @standard_reservation
  end

  def create

    @standard_reservation = StandardReservation.new(create_params)
    authorize @standard_reservation

    if @standard_reservation.save
      @schedule_another_html = view_context.link_to("Schedule another reservation", new_standard_reservation_path, {class: 'btn btn-info'})
      flash[:success] = t "#{@i18n_path}.success", scope: "forms", start: @standard_reservation.start, lab: @standard_reservation.lab.titleize, schedule_another_html: @schedule_another_html
      redirect_to standard_reservations_path
    else
      flash[:danger] = t :submission_errors, scope: "forms"
      render :new
    end
  end

  def show

    authorize @standard_reservation
  end

  def edit

    authorize @standard_reservation
  end

  def update

    authorize @standard_reservation

    if @standard_reservation.update(update_params)
      flash[:success] = t "#{@i18n_path}.success", scope: "forms", start: @standard_reservation.start, lab: @standard_reservation.lab.titleize
      redirect_to standard_reservations_path
    else
      flash[:danger] = t "submission_errors", scope: "forms"
      render :edit
    end
  end

  def destroy

    authorize @standard_reservation

    if @standard_reservation.destroy
      flash[:success] = t "#{@i18n_path}.success", scope: "forms", start: @standard_reservation.start
      redirect_to standard_reservations_url
    else
      render :edit
    end
  end

  private

  def set_standard_reservation
    @standard_reservation = StandardReservation.find(params[:id])
  end

  def create_params
    params.require(:standard_reservation).permit(policy(StandardReservation).create_attributes)
  end

  def update_params
    params.require(:standard_reservation).permit(policy(@standard_reservation).update_attributes)
  end
end
