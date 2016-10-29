class ReservationViabilityController < ApplicationController

    def viable_labs
        params[:start] = params[:start].to_datetime
        params[:end] = params[:end].to_datetime
        
        @standard_reservations = StandardReservation.where("start >= ? AND standard_reservations.end <= ?", params[:start], params[:end])
        @project_reservations = ProjectReservation.where("start >= ? AND project_reservations.end <= ?", params[:start], params[:end])
        
        # Everything starts off viable, and is restricted by existing reservations, and workstation availability
        @res = {
            standard_reservation_count: @standard_reservations.count,
            project_reservation_count: @project_reservations.count,
            viable_labs: {
                a: true,
                a_workstations: true,
                b: true,
                b_workstations: true,
                b_can_move: true,
                c: true,
                c_workstations: true,
                c_and_a: true,
                c_and_a_workstations: true,
            }
        }
        
        # Look for conflicts with existing reservations
        @standard_reservations.each do |sr|
            # Only lab B has the document viewer
            if (sr.lab == "b" && (sr.utilities.include? "document_viewer"))
                @res[:viable_labs][:b_can_move] = false
                @res[:viable_labs][:b] = false
            else
                if (sr.lab == "c_and_a")
                    @res[:viable_labs][:c] = false
                    @res[:viable_labs][:a] = false
                end
                
                @res[:viable_labs][:c_and_a] = false
                @res[:viable_labs][sr.lab] = false
            end
        end
        
        @project_reservations.each do |pr|
            # Training sessions should always be in lab B
            if (pr.lab == "b" && (pr.category == "training"))
                @res[:viable_labs][:b_can_move] = false
                @res[:viable_labs][:b] = false
            else
                if (sr.lab == "c_and_a")
                    @res[:viable_labs][:c] = false
                    @res[:viable_labs][:a] = false
                end
                
                @res[:viable_labs][:c_and_a] = false
                @res[:viable_labs][sr.lab] = false
            end
        end
        
        # Restrict labs if there aren't enough workstations
        @res[:viable_labs][:a_workstations] = false if Lab::WORKSTATIONS[:a] < 25
        @res[:viable_labs][:b_workstations] = false if Lab::WORKSTATIONS[:b] < 25
        @res[:viable_labs][:c_workstations] = false if Lab::WORKSTATIONS[:c] < 25
        @res[:viable_labs][:c_and_a_workstations] = false if Lab::WORKSTATIONS[:c_and_a] < 25
        
        render json: @res
    end
end