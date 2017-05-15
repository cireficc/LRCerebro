class ConvertStandardReservationActivityToString < ActiveRecord::Migration
  def change
    change_column :standard_reservations, :activity, :string

    # Mapping for int enum values to string representation
    standard_reservation_activities = {
        0 => "DiLL Paired (Synchronous) Recordings",
        1 => "DiLL Individual (Asynchronous) Recordings",
        2 => "Writing or Web Research",
        3 => "Film Viewing",
        4 => "Other",
        5 => "LRC Orientation"
    }

    # Convert the old enum ints to their new string representation
    StandardReservation.all.each do |sr|
      int = sr[:activity].to_i
      sr.update_attributes(activity: standard_reservation_activities[int])
    end
  end
end
