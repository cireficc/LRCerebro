class StandardReservationsController < ApplicationController
    
    before_action :set_standard_reservation, only: [:show, :edit, :update, :destroy]

    def index
        
        
        @standard_reservations = policy_scope(StandardReservation).order(start: :desc)
        @past = @standard_reservations.where("start < ?", ApplicationHelper.time_local(Time.now))
        @upcoming = @standard_reservations.where("start >= ?", ApplicationHelper.time_local(Time.now))
    end

    def new
        
        @standard_reservation = StandardReservation.new
        authorize @standard_reservation
    end

    def create
        
        @standard_reservation = StandardReservation.new(create_params)
        authorize @standard_reservation

        if @standard_reservation.save
            flash[:success] = t "#{@i18n_path}.success", scope: "forms", start: @standard_reservation.start, lab: @standard_reservation.lab.titleize
            redirect_to @standard_reservation
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
            redirect_to @standard_reservation
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
